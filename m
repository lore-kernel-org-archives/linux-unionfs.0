Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 014D0C433EF
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 Oct 2021 21:51:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAB41611CB
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 Oct 2021 21:51:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbhJTVxQ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 20 Oct 2021 17:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhJTVxO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 20 Oct 2021 17:53:14 -0400
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEAFEC06161C
        for <linux-unionfs@vger.kernel.org>; Wed, 20 Oct 2021 14:50:59 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id r22so9417634uat.11
        for <linux-unionfs@vger.kernel.org>; Wed, 20 Oct 2021 14:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nextdayvideo-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=xcxvX64IEDpdCEF/ZFYBh/S3uVtg9e2eHrKQ0tzJOYE=;
        b=rn7yDu9y6c8ZXF/ps2xqiiICoHYZscC1MBs7lntgYLfcqr/Nzb6P7G8SP7EOOBljJg
         XUabBjwGtG+YvLF6bz1YxjByKRgcaCagJHwMmBjSPk1BuImT71HsLDpCmP1E7zaibH4Z
         6gVn029DvBkLmmfBU7NjW45MbFBHZRzTV5q8ZE70lTiTZW/TzY/g01uR4UIu+s/eV+Lr
         OESp4/CCFoQpfrljeu+0nD22YREsqidl729K/uUH8aqjrbrPA61IEqJq0bPOcoOqPD9Z
         AeXdzFkDJOJijbSIIlKCWLBGFIbWBCktKpbpb9Zr1dA2ylcocPdPS6Ts8Ft6A6FPDNOL
         9FcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=xcxvX64IEDpdCEF/ZFYBh/S3uVtg9e2eHrKQ0tzJOYE=;
        b=FKllHP/VvE6DxgONGGkgSjyHb5lJWNVsHFdGDrgustL4SFean7wl6rj1tbBJnPrcku
         TprkIosMwFOzgILW3g8zHcCUgDggKlPVssLYmtbqS1EWV7LsR9w07io5tIQ3GG1H/sjq
         y5hDNJRvIFucxDVnia496IoeABBqsUCikx0EUMaj8xBOGFNOXROAtTBkAbLRZdnAsvE1
         q9OD5k8rwO7g232sigEKSnT0e5KUsBqyO6sKMM0bA41nvuKGGyHlQD+2AQyWWE1hFNWS
         nKKFkWH9l/SVCNm4ycWILvNUhiW0iMdu6iek0ZD+xgfi4B4XNom/yazuIhUyyx3X9VTo
         L8MA==
X-Gm-Message-State: AOAM530J84VPmL2p1uuuJHx86799sifB/o6pFEVs4YoBFGwgoeB4YTqe
        0gGNzYwQbePx/bMDEc8qEEdXi+VwbMuBuCXODRbe0EYH5NM=
X-Google-Smtp-Source: ABdhPJzcwR/1nlw83dLQXvCS08i8QcXKwVaZBbJ01K9J5w2sO/c4Xw8WkxHCLDD5jNHJdtEv7s3KRDHo1IQ8K5YiujE=
X-Received: by 2002:ab0:136d:: with SMTP id h42mr2639094uae.40.1634766658647;
 Wed, 20 Oct 2021 14:50:58 -0700 (PDT)
MIME-Version: 1.0
From:   Carl Karsten <carl@nextdayvideo.com>
Date:   Wed, 20 Oct 2021 16:50:32 -0500
Message-ID: <CADmzSSjy+bzPUus3xO2zT_USEKZYJ7WBOCbOiF+ro3EDoipXqg@mail.gmail.com>
Subject: nfs server serving ... wrong mount?
To:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

I have 2 overlayfs monts.

I can nfs export one or the other fine, but not both at the same time,
the client gets the wrong files.

server hosthame negk bullseye ext4
client twist ubuntu

juser@negk:~$ cat /etc/exports
# /srv/nfs/rpi/buster/boot/merged *(ro,sync,no_subtree_check,no_root_squash)
/srv/nfs/rpi/buster/root/merged *(ro,sync,no_subtree_check,no_root_squash)

juser@negk:~$ ls /srv/nfs/rpi/buster/boot/merged
bcm2708-rpi-b.dtb       bcm2710-rpi-3-b-plus.dtb  fixup4cd.dat
kernel7.img       start4.elf
(snip)

juser@negk:~$ ls /srv/nfs/rpi/buster/root/merged
bin  boot  dev  etc  home  lib  lost+found  media  mnt  opt  proc
root  run  sbin  srv  sys  tmp  usr  var

carl@twist:~/mnt$ sudo mount -t nfs negk:/srv/nfs/rpi/buster/root/merged nfs
carl@twist:~/mnt$ ls nfs
bin  boot  dev  etc  home  lib  lost+found  media  mnt  opt  proc
root  run  sbin  srv  sys  tmp  usr  var
carl@twist:~/mnt$ sudo umount nfs

# enable root in negk exports...

carl@twist:~/mnt$ sudo mount -t nfs negk:/srv/nfs/rpi/buster/root/merged nfs
carl@twist:~/mnt$ ls nfs
bcm2708-rpi-b.dtb       bcm2710-rpi-3-b-plus.dtb  fixup4cd.dat
kernel7.img       start4.elf
(snip)


juser@negk:~$ cat /etc/fstab
# /etc/fstab: static file system information.

/dev/mapper/negk--vg-root /               ext4    errors=remount-ro 0       1
UUID=c031c4a4-3eda-4fb9-99ac-ce2cb9d05243 /boot           ext2
defaults        0       2
/dev/mapper/negk--vg-swap_1 none            swap    sw              0       0

# rpi netboot boot: base, setup, updates = merged
overlay   /srv/nfs/rpi/buster/boot/merged    overlay
noauto,defaults,lowerdir=/srv/nfs/rpi/buster/boot/setup:/srv/nfs/rpi/buster/boot/base,upperdir=/srv/nfs/rpi/buster/boot/updates,workdir=/srv/nfs/rpi/buster/boot/work,nfs_export=on
   0   2

# rpi netboot root: base, setup, updates = merged
overlay   /srv/nfs/rpi/buster/root/merged    overlay
noauto,defaults,lowerdir=/srv/nfs/rpi/buster/root/setup:/srv/nfs/rpi/buster/root/base,upperdir=/srv/nfs/rpi/buster/root/updates,workdir=/srv/nfs/rpi/buster/root/work,nfs_export=on
  0   2

server setup: https://github.com/CarlFK/pici/blob/main/setup2.sh

-- 
Carl K
