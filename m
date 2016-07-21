From: Vito Caputo <vito.caputo@coreos.com>
Subject: Stable inode numbers
Date: Thu, 21 Jul 2016 16:33:38 -0700
Message-ID: <CAKp8XJ41QeG03E_AW4cxsuyp4-uxrPWAkhKc60OMp3vK2YAADA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:33341 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbcGUXdj (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 21 Jul 2016 19:33:39 -0400
Received: by mail-io0-f182.google.com with SMTP id 38so90476812iol.0
        for <linux-unionfs@vger.kernel.org>; Thu, 21 Jul 2016 16:33:39 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

Hello list,

We're receiving bug reports from users simply untarring archives onto overlayfs
mounts (docker + overlayfs) where tar fails with "Directory renamed before its
status could be extracted" errors.

This is triggered in GNU tar when the inode number of an ancestor directory
changes unexpectedly in the deferred application of ancestral metadata.

It's not consistently reproducible, but in a slightly memory-constrained vm it
is very easy to reproduce.

What appears to be happening is the tar extraction activity is churning through
the kernel's cache so a subsequent lookup of the directory in question returns
a new inode number.  One can easily simulate this using `stat` and `echo 2 >
/proc/sys/vm/drop_caches` to observe the overlayfs inode number change across
the cache drop.

The seemingly erratic nature of this failure is particularly frustrating for
users, as it gives the impression things _should_ work and just randomly aren't
due to a bug.  Scrutiny of the overlayfs implementation reveals that unstable
inode numbers is intentional, and spurious failures of applications which
notice intersecting relevant cache evictions should be expected.

Are there any plans or strategies for changing this situation in overlayfs?

I can think of a few potential solutions, but they all tend to revolve around
persistently allocating inode numbers on first lookup, which of course requires
both space and time overlayfs currently elides.

Cheers,
Vito Caputo
