<?php
/**
 * Auto Home Backup Dropbox Uploader PHP Script
 * v#BUILD_VERSION# #BUILD_DATE# #GIT_HASH#
 * https://github.com/idachev/autohomebackup
 * Copyright (c) #BUILD_YEAR# Ivan Dachev
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * It uses the https://github.com/kunalvarma05/dropbox-php-sdk
 */

require __DIR__ . '/vendor/autoload.php';

use Kunnu\Dropbox\Dropbox;
use Kunnu\Dropbox\DropboxApp;
use Kunnu\Dropbox\DropboxFile;

function stripUtf8Bom($string)
{
    if (\substr_compare($string, "\xEF\xBB\xBF", 0, 3) === 0) {
        $string = \substr($string, 3);
    }
    return $string;
}

/**
 * Loads a JSON file containing authorization information for your app. 'php authorize.php'
 * in the examples directory for details about what this file should look like.
 *
 * @param string $path
 *    Path to a JSON file
 * @return array
 *    A <code>list(string $accessToken, Host $host)</code>.
 *
 * @throws Exception
 */
function loadFromJsonFile($path)
{
    if (!file_exists($path)) {
        throw new Exception("File doesn't exist: \"$path\"");
    }

    $str = stripUtf8Bom(file_get_contents($path));
    $jsonArr = json_decode($str, true, 10);

    if (is_null($jsonArr)) {
        throw new Exception("JSON parse error: \"$path\"");
    }

    return loadFromJson($jsonArr);
}

/**
 * Parses a JSON object to build an AuthInfo object.  If you would like to load this from a file,
 * please use the @see loadFromJsonFile method.
 *
 * @param array $jsonArr
 *    A parsed JSON object, typcally the result of json_decode(..., true).
 * @return array
 *    A <code>list(string $accessToken, Host $host)</code>.
 *
 * @throws Exception
 */
function loadFromJson($jsonArr)
{
    if (!is_array($jsonArr)) {
        throw new Exception("Expecting JSON object, found something else");
    }

    // Check access_token
    if (!array_key_exists('access_token', $jsonArr)) {
        throw new Exception("Missing field \"access_token\"");
    }

    $accessToken = $jsonArr['access_token'];
    if (!is_string($accessToken)) {
        throw new Exception("Expecting field \"access_token\" to be a string");
    }

    // Check for the optional 'host' field
    if (!array_key_exists('host', $jsonArr)) {
        $host = null;
    } else {
        $baseHost = $jsonArr["host"];
        if (!is_string($baseHost)) {
            throw new Exception("Optional field \"host\" must be a string");
        }

        $api = "api-$baseHost";
        $content = "api-content-$baseHost";
        $web = "meta-$baseHost";

        $host = new Host($api, $content, $web);
    }

    return array($accessToken, $host);
}

/**
 * @param $configPath
 * @param $pathToLocalFile
 * @param $pathToRemoteFile
 *
 * @throws Exception
 */
function uploadFile($configPath, $pathToLocalFile, $pathToRemoteFile)
{
    $accessToken = loadFromJsonFile($configPath)[0];

    $app = new DropboxApp("", "", $accessToken);

    $dropbox = new Dropbox($app);

    $mode = DropboxFile::MODE_READ;
    $dropboxFile = new DropboxFile($pathToLocalFile, $mode);

    $file = $dropbox->upload($dropboxFile, $pathToRemoteFile, ['autorename' => true]);

    print_r($file);
}

function main()
{
    global $argv;

    $authConfig = $argv[1];
    $pathToLocalFile = $argv[2];
    $pathToRemoteFile = $argv[3];

    uploadFile($authConfig, $pathToLocalFile, $pathToRemoteFile);
}

main();
