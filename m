From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [GIT PULL] overlayfs fixes for 4.6-rc7
Date: Wed, 11 May 2016 01:23:42 +0200
Message-ID: <20160510232342.GE10623@veci.piliscsaba.szeredi.hu>
References: <20160503200403.GB10623@veci.piliscsaba.szeredi.hu>
 <20160510152704.GK2694@ZenIV.linux.org.uk>
 <20160510202458.GD10623@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35297 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbcEJXXr (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 10 May 2016 19:23:47 -0400
Received: by mail-wm0-f66.google.com with SMTP id e201so5872926wme.2
        for <linux-unionfs@vger.kernel.org>; Tue, 10 May 2016 16:23:46 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160510202458.GD10623@veci.piliscsaba.szeredi.hu>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

Hi Al,

Hopefully this addresses your concerns.  I couldn't find a better name for
lookup_hash(), after all it's just that.

Please pull:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-linus

---
Miklos Szeredi (4):
      vfs: add vfs_select_inode() helper
      vfs: rename: check backing inode being equal
      vfs: add lookup_hash() helper
      ovl: ignore permissions on underlying lookup

---
 fs/internal.h         |  2 ++
 fs/namei.c            | 39 +++++++++++++++++++++++++++++++++------
 fs/open.c             | 23 ++++++++++++++---------
 fs/overlayfs/super.c  |  4 +---
 include/linux/namei.h |  2 ++
 5 files changed, 52 insertions(+), 18 deletions(-)
