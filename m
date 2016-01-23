From: Ignacy =?iso-8859-2?Q?Gaw=EAdzki?=
	<ignacy.gawedzki@green-communications.fr>
Subject: Unreliable permission checking with OverlayFS
Date: Sun, 24 Jan 2016 00:21:28 +0100
Message-ID: <20160123232127.GA16726@zenon.in.qult.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from str75-3-78-193-33-39.fbxo.proxad.net ([78.193.33.39]:52795 "EHLO
	mail.qult.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbcAWXjU (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Sat, 23 Jan 2016 18:39:20 -0500
Received: from zenon.in.qult.net ([192.168.64.1])
	by mail.qult.net with esmtps (TLS1.2:RSA_AES_128_CBC_SHA1:128)
	(Exim 4.82)
	(envelope-from <ignacy.gawedzki@green-communications.fr>)
	id 1aN7Un-0001yK-Ub
	for linux-unionfs@vger.kernel.org; Sun, 24 Jan 2016 00:21:30 +0100
Received: from ig by zenon.in.qult.net with local (Exim 4.86)
	(envelope-from <ignacy.gawedzki@green-communications.fr>)
	id 1aN7Um-0004V1-19
	for linux-unionfs@vger.kernel.org; Sun, 24 Jan 2016 00:21:28 +0100
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

Hi,

It seems some results of permission checking are cached in situations
where it looks like they shouldn't be.

See the following test-case:

  # umask 022
  # mkdir ro rw work mnt
  # chmod 700 ro
  # echo bar > ro/foo
  # mount overlay -t overlay -olowerdir=3D$PWD/ro,upperdir=3D$PWD/rw,wo=
rkdir=3D$PWD/work mnt
  # echo 3 > /proc/sys/vm/drop_caches
  # sudo -u nobody cat mnt/foo
  cat: mnt/foo: Permission denied
  # cat mnt/foo
  bar
  # sudo -u nobody cat mnt/foo
  bar

So it seems that when the caches are empty, checking access to mnt/foo
eventually checks access to ro/foo, which for user nobody is denied.
But as soon as some user that has access to underlying ro/foo triggers
a successful access to mnt/foo, user nobody succeeds in accessing it
as well.

I admit this setup is a bit twisted, but I suppose this behavior
qualifies as a bug.

Cheers,

Ignacy

PS: I've filed a bug in the kernel bugtracker about this issue as
well: https://bugzilla.kernel.org/show_bug.cgi?id=3D111131 .

--=20
Ignacy Gaw=EAdzki
R&D Engineer
Green Communications
