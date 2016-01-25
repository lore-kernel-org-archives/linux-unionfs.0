From: Ignacy =?iso-8859-2?Q?Gaw=EAdzki?=
	<ignacy.gawedzki@green-communications.fr>
Subject: Re: Unreliable permission checking with OverlayFS
Date: Mon, 25 Jan 2016 11:09:19 +0100
Message-ID: <20160125100919.GA19468@zenon.in.qult.net>
References: <20160123232127.GA16726@zenon.in.qult.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from str75-3-78-193-33-39.fbxo.proxad.net ([78.193.33.39]:57691 "EHLO
	mail.qult.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932276AbcAYKJZ (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 25 Jan 2016 05:09:25 -0500
Received: from zenon.in.qult.net ([192.168.64.1])
	by mail.qult.net with esmtps (TLS1.2:RSA_AES_128_CBC_SHA1:128)
	(Exim 4.82)
	(envelope-from <ignacy.gawedzki@green-communications.fr>)
	id 1aNe5M-0003oK-Py
	for linux-unionfs@vger.kernel.org; Mon, 25 Jan 2016 11:09:24 +0100
Received: from ig by zenon.in.qult.net with local (Exim 4.86)
	(envelope-from <ignacy.gawedzki@green-communications.fr>)
	id 1aNe5H-0005sx-WC
	for linux-unionfs@vger.kernel.org; Mon, 25 Jan 2016 11:09:20 +0100
Content-Disposition: inline
In-Reply-To: <20160123232127.GA16726@zenon.in.qult.net>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

Hi again,

I played around a bit with permissions and OverlayFS and found the
following general odd behavior.  When caches are empty and access
permissions are checked, the upper layer is checked first and if that
passes, the lower layer is checked next.  Apart from the fact that
some positive check results are cached regardless of the accessing
UID, it seems that the checking procedure itself is wrong.

Take the following example: in the lower directory there's a directory
foo with permissions 0700, containing some world-readable file.  In
the upper layer, the same directory foo exists but with permissions
0755.

  drwxr-xr-x lower/
  drwx------ lower/foo/
  -rw-r--r-- lower/foo/bar

  drwxr-xr-x upper/
  drwxr-xr-x upper/foo/

This situation would happen after the permissions of foo are
changed from 0700 to 0755 in the overlay directory.  Then when
permissions are checked for access to that file in foo, the
permissions of foo in the lower directory should be ignored in favor
of the permissions of foo in the upper directory.

In other words, as the documentation of OverlayFS itself puts it:

  "Only the lists of names from directories are merged.  Other content
  such as metadata and extended attributes are reported for the upper
  directory only.  These attributes of the lower directory are hidden."

As I understand it, as soon as upper/foo exists its permissions should
completely override those of lower/foo.  This is obviously actually
not the case as anyone not allowed to read lower/foo/bar who tries to
read foo/bar from the overlay when the caches are empty is actually
denied access.

Cheers,

Ignacy

--=20
Ignacy Gaw=EAdzki
R&D Engineer
Green Communications
