From: Linzhe Lee <slayercat.subscription@gmail.com>
Subject: Question about overlayfs over fs not support dirent::ftype
Date: Wed, 9 Dec 2015 12:42:50 +0800
Message-ID: <CAK_yBkOjkk_70-EvZs_TcRh9Rb7S9jwPQ=AAREHEQToZ+o5sSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:36034 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbbLIEmu (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 8 Dec 2015 23:42:50 -0500
Received: by qgcc31 with SMTP id c31so57534504qgc.3
        for <linux-unionfs@vger.kernel.org>; Tue, 08 Dec 2015 20:42:50 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

Hi,all

I got problem in using overlayfs over fs not support
dirent::ftype[such as xfs(-n ftype=0)]. After some dig I realized in
such situation, function ovl_fill_merge parameter d_type will always
be DT_UNKNOWN.

I think a warning is needed of course. But because dirent::d_type is
not widely supported for now. I thought If we can find a way to
fallback to stat() call in such a situation.  How do you think this
idea?

And, can you suggest a method to do it? I tried these method for now,
but none work.

    1) Direct get struct inode* from inode::i_ino,  Stuck at not found
a proper abstract function to do it.
    2) Get to known fs do not support dirent::d_type and workaround.
Stuck at not found how to know if fs do not support dirent::d_type
    3) In function ctx.actor [ovl_fill_merge], use function
lookup_one_len to get file dirent. Stuck at lock.

Any thought is helpful. Thank you !

lilinzhe
