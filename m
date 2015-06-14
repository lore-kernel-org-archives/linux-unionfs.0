From: james harvey <jamespharvey20@gmail.com>
Subject: Mount doesn't show subvol option for btrfs
Date: Sun, 14 Jun 2015 16:50:07 -0400
Message-ID: <CA+X5Wn4Hs5HeHwcH1X0bZ5=NxxdcVeOdx60HC5QSTDr=hmQuyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:34196 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbbFNUuK (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Sun, 14 Jun 2015 16:50:10 -0400
Received: by labbc20 with SMTP id bc20so10261179lab.1
        for <linux-unionfs@vger.kernel.org>; Sun, 14 Jun 2015 13:50:08 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

Not sure if this could be a util-linux (mount) bug instead...

On arch, /etc/fstab includes:

/dev/sda1   /.snapshots   btrfs
rw,noatime,compress=lzo,ssd,discard,space_cache,subvol=.snapshots   0
 0

But mount includes:

/dev/sda1 on /.snapshots type btrfs
(rw,noatime,compress=lzo,ssd,discard,space_cache)

The subvol option isn't reported in mount.

This happens on all of my btrfs mounts, not just .snapshots.
