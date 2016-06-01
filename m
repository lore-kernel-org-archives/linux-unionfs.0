From: Badhri Jagan Sridharan <badhri@google.com>
Subject: Is selinux expected to work on overlayfs ?
Date: Tue, 31 May 2016 22:55:50 -0700
Message-ID: <CAPTae5+yS2QvTz=sw+Jm-xt39srms4nEvxQz8yj2z=2TGV56bw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:36359 "EHLO
	mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243AbcFAFzv (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 1 Jun 2016 01:55:51 -0400
Received: by mail-vk0-f49.google.com with SMTP id a6so12644724vkg.3
        for <linux-unionfs@vger.kernel.org>; Tue, 31 May 2016 22:55:51 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu

Hi,

I am playing with overlays in one of our development boards.
The kernel is based of 3.18..

I notice that the selinux label becomes corrupted (unlabeled) once
overlayfs is mounted.

/ # ls -Z /system/bin/vold
u:object_r:vold_exec:s0 /system/bin/vold
/ # mount -t overlay -o lowerdir=/system,upperdir=/cache/upper,
workdir=/cache/working overlayfs /system
/ # ls -Z /system/bin/vold
u:object_r:unlabeled:s0 /system/bin/vold

https://lwn.net/Articles/636943/ article quotes that the selinux issues have
been solved for overlayfs. Since the target is running on 3.18 kernel I am
wondering whether porting the recent patches on overlayfs would solve the
issue ? Or this behavior is expected for overlayfs..

Any pointers is much appreciated !!

Thanks.
