Return-Path: <SRS0=Ys2z=CK=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6761CC433E2
	for <linux-unionfs@archiver.kernel.org>; Tue,  1 Sep 2020 18:01:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52B822078B
	for <linux-unionfs@archiver.kernel.org>; Tue,  1 Sep 2020 18:01:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbgIASBd (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 14:01:33 -0400
Received: from relaygw4-24.mclink.it ([195.78.211.250]:52671 "EHLO
        relaygw4-24.mclink.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbgIASBd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 1 Sep 2020 14:01:33 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Sep 2020 14:01:32 EDT
Received: from [172.24.30.45] (HELO cgp-esgout02-rm.mail.irds.it)
  by relaygw4-24.mclink.it (CommuniGate Pro SMTP 6.0.6)
  with ESMTPS id 185401320 for linux-unionfs@vger.kernel.org; Tue, 01 Sep 2020 19:46:27 +0200
X-Envelope-From: <mc5686@mclink.it>
Received: from [192.168.7.128] (host-82-53-147-214.retail.telecomitalia.it [82.53.147.214])
        (Authenticated sender: mc5686)
        by cgp-esgout02-rm.mail.irds.it (Postfix) with ESMTPA id B427A41B62
        for <linux-unionfs@vger.kernel.org>; Tue,  1 Sep 2020 19:46:03 +0200 (CEST)
To:     linux-unionfs@vger.kernel.org
From:   Mauro Condarelli <mc5686@mclink.it>
Subject: Frequent errors with OverlayFS on root
Message-ID: <d5dc093b-71aa-8656-a4d3-c27c14015d79@mclink.it>
Date:   Tue, 1 Sep 2020 19:46:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Irideos-Libra-ESVA-Information: Please contact Irideos for more information
X-Irideos-Libra-ESVA-ID: B427A41B62.A73AE
X-Irideos-Libra-ESVA: No virus found
X-Irideos-Libra-ESVA-From: mc5686@mclink.it
X-Irideos-Libra-ESVA-Watermark: 1599587165.49847@LYjqIzonjN8SRFFA5dcNVQ
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi,
most likely this is not the right place to ask, please redirect me as needed.

I'm trying to use OverlayFS to add (limited) write capability to a ReadOnly
rootfs (SquashFS)

Essentially (actual script is more complex, of course) boot-sequence includes:

# /dev/mmcblk0p5: ext4 (upper+work+nwwroot+newroot/oldroot)
# /dev/mmcblk0p6: SquashFS mounted on /
mount /dev/mmcblk0p5 /overlay
mount -t overlay overlay -o lowerdir=/,upperdir=/overlay/upper,workdir=/overlay/work  /overlay/newroot
cd /overlay/newroot
pivot_root . oldroot
mount --move oldroot/dev /dev
mount --move oldroot/proc /proc

This works as expected, but, too often for comfort, some file
(and sometime also directories) become unavailable due to error:

overlayfs: invalid origin (ssh/sshd_config, ftype=8000, origin ftype=4000).

File name changes, of course, but rest is fairly constant.

This always happens when some file is written.
Error persists reboots.
Only way I found to "cure" the system is to go on "upper" and delete the file
thus going back to "lower" version (in this case I should delete "/oldroot/overlay/upper/etc/ssh/sshd_config")

This is a self-built kernel (Linux vocore 5.7.0 #2 PREEMPT Mon Aug 3 09:19:06 CEST 2020 mips GNU/Linux)
on a custom target based on a SoC (MT7628).

I am available to do any required test, but I have no idea about where to start.

Any hint (or redirect) would be greatly appreciated.

Many Thanks in Advance
Mauro


