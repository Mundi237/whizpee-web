// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

/// Regex to check if text is email.
const regexEmail = r'([a-zA-Z0-9+._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9_-]+)';

/// Regex to check if content type is an image.
const regexImageContentType = r'image\/*';

/// Regex to find all links in the text.
const regexLink =
    r'((http|ftp|https):\/\/)?([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?';

final vMentionRegExp = RegExp(r"\[(@[^:]+):([^\]]+)\]");
