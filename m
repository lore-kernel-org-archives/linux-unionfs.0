From: james harvey <jamespharvey20@gmail.com>
Subject: Overlay filesystem doesn't feed "tail -f"
Date: Tue, 9 Jun 2015 19:27:06 -0400
Message-ID: <CA+X5Wn43D7+LKyYrz5UCm7rXvvzL84g2WNKTKHJP35EEXRyRHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:36221 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbbFIX1I (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 9 Jun 2015 19:27:08 -0400
Received: by lbbqq2 with SMTP id qq2so18838179lbb.3
        for <linux-unionfs@vger.kernel.org>; Tue, 09 Jun 2015 16:27:06 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

If a file in an overlay merged directory is being periodically written
to: tail -f will not show additions if given the file in the location
of the merged directory; but tail -f will show additions if given the
file in the location of the lower directory.

On a fresh Fedora 22 (kernel 4.0.4-303.fc22) (netinstaller, so most up
to date packages, "Minimal Install") or a fresh Arch Linux (kernel
4.0.5-1-ARCH), running through VMWare Workstation 11.1, I experience
the following bug.

1. mkdir lowerdir upperdir merged workdir
2. sudo modprobe overlay
3. sudo mount -t overlay -o
lowerdir=/home/username/lowerdir,upperdir=/home/username/upperdir,workdir=/home/username/workdir
overlay /home/username/merged
4. cd merged
5. while true; do echo hello >> while.loop.out; sleep 1; done &
6. ls -la while.loop.out, wait a few seconds, run again, wait, run
again.  (observe while.loop.out is growing.)
7. tail -f while.loop.out.  observe the most recent 10 lines, and no updates.
8. tail -f ../upperdir/while.loop.out.  observe while.loop.out's updates.
9. cleanup.  fg, then CTRL+C

I'm betting this is a kernel/overlay filesystem bug rather than a tail
bug.  Tail should not know or care whether it's being given a file in
an overlay filesystem.
