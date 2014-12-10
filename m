From: Weng Xuetian <wengxt@gmail.com>
Subject: Problem with overlayfs and switch_root
Date: Wed, 10 Dec 2014 15:03:40 -0500
Message-ID: <2031284.s7T0BrCJ3o@chakra-yoga2>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:57922 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088AbaLJUDm (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 10 Dec 2014 15:03:42 -0500
Received: by mail-qa0-f46.google.com with SMTP id n8so2532369qaq.33
        for <linux-unionfs@vger.kernel.org>; Wed, 10 Dec 2014 12:03:42 -0800 (PST)
Received: from chakra-yoga2.localnet (sbldar101.cs.sunysb.edu. [130.245.26.101])
        by mx.google.com with ESMTPSA id p9sm5180425qax.8.2014.12.10.12.03.40
        for <linux-unionfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Dec 2014 12:03:41 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

Hi,
I'm trying to port Chakra's live cd from aufs to overlayfs since overlay fs is 
now in 3.18. Since I need multiple lowerdir support so I also grab the code 
from overlayfs-next.

Before switch_root, the mount setup is:
* squashfs is mounted at /ro_branch/root-image, /ro_branch/overlay-pkgs, 
/ro_branch/overlay
* tmpfs is mounted at /rw_branch
* Overlayfs is mounted at /new_root with option lowerdir=/ro_branch/overlay-
pkgs:/ro_branch/overlay:/ro_branch/root-
image,upperdir=/rw_branch/uppper,workdir=/rw_branch/work .

Then it will switch_root to /new_root .

Now system boots fine, but with one strange problem, if I execute ls / , it 
shows that there's nothing under / . But I can access files and directory with 
full path.

What's the possible problem that can cause this?

Thanks,
Xuetian
