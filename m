From: Raphael Hertzog <raphael@ouaza.com>
Subject: Regression in overlayfs in 4.13: "could not fsync file" error by
 PostgreSQL
Date: Fri, 3 Nov 2017 15:00:46 +0100
Message-ID: <20171103140046.h6oabi5tjqqvj6uj@home.ouaza.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail.vm.ouaza.com ([212.83.178.2]:53503 "EHLO mail.vm.ouaza.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756306AbdKCOJG (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 3 Nov 2017 10:09:06 -0400
Received: from x260-buxy.home.ouaza.com (133-218-190-109.isp.overthebox.ovh [109.190.218.133])
        by mail.vm.ouaza.com (Postfix) with ESMTPSA id 4D1E620A32
        for <linux-unionfs@vger.kernel.org>; Fri,  3 Nov 2017 15:00:46 +0100 (CET)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

Hello,

the Kali live image contains PostgreSQL and with our latest image[1]
PostgreSQL is no longer able to create a new database (/ is an overlayfs
merging a RO squashfs filesystem and an empty RW tmpfs).

[1] http://cdimage.kali.org/kali-weekly/kali-linux-2017-W43-amd64.iso
(if 404 look up the parent directory and pick the currently available
weekly image)

You get messages like this while running createdb:
createdb: database creation failed: ERROR: checkpoint request failed
HINT: Consult recent messages in the server log for details.

And in the server log you have this:
ERROR: could not fsync file "pg_commit_ts": Invalid argument

This was working with Linux 4.12.6 and seems to be broken in Linux 4.13.4
that we currently have in Kali Linux.

Does this ring a bell to anyone ? I saw a few patches in 4.13.6 but their
description does not seem to match the error I'm getting.

What else can I provide to help you diagnose this issue ?

This bug report has been filed against Kali Linux in the first place:
https://bugs.kali.org/view.php?id=4332

Cheers,
-- 
Raphaël Hertzog ◈ Writer/Consultant ◈ Debian Developer

Discover the Debian Administrator's Handbook:
→ https://debian-handbook.info/get/
