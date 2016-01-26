From: Ignacy =?iso-8859-2?Q?Gaw=EAdzki?=
	<ignacy.gawedzki@green-communications.fr>
Subject: [PATCH 0/1] OverlayFS: Fix checking permissions during lookup.
Date: Tue, 26 Jan 2016 09:38:19 +0100
Message-ID: <20160126083819.GA18883@zenon.in.qult.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from str75-3-78-193-33-39.fbxo.proxad.net ([78.193.33.39]:33063 "EHLO
	mail.qult.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932404AbcAZIiX (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 26 Jan 2016 03:38:23 -0500
Received: from zenon.in.qult.net ([192.168.64.1])
	by mail.qult.net with esmtps (TLS1.2:RSA_AES_128_CBC_SHA1:128)
	(Exim 4.82)
	(envelope-from <ignacy.gawedzki@green-communications.fr>)
	id 1aNz8m-0007Yv-UX
	for linux-unionfs@vger.kernel.org; Tue, 26 Jan 2016 09:38:21 +0100
Received: from ig by zenon.in.qult.net with local (Exim 4.86)
	(envelope-from <ignacy.gawedzki@green-communications.fr>)
	id 1aNz8l-0004vK-UR
	for linux-unionfs@vger.kernel.org; Tue, 26 Jan 2016 09:38:19 +0100
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

Hi,

While trying to figure out what exactly is going on with permission
checking in OverlayFS, I found a pretty simple way to, so it seems,
fix it.

The problem I was having is triggered with the following setup:

  drwxr-xr-x lower/
  drwx------ lower/foo/
  drw-r--r-- lower/boo/bar
  drwxr-xr-x upper/
  drwxr-xr-x upper/foo/

mounted with lower/ as the lowerdir and upper/ as the upperdir.

The issue is that when caches are empty, any user who is not the
owner of lower/foo/ and who tries to access foo/bar on the mounted
overlay gets EACCES.  Once the owner accesses foo/bar, that positive
result it cached and other users can access foo/bar as expected.

It would be nice if someone could take a look at the patch that
follows and give me some feedback.  The fix is simple, but a bit
intrusive and I wonder whether this is necessarily the way to go.

Cheers,

Ignacy

Ignacy Gaw=EAdzki (1):
  OverlayFS: Fix checking permissions during lookup.

 fs/namei.c            | 21 ++++++++++++++++++++-
 fs/overlayfs/super.c  |  2 +-
 include/linux/namei.h |  1 +
 3 files changed, 22 insertions(+), 2 deletions(-)

--=20
2.5.0
