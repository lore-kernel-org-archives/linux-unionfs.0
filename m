Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC3D4C43217
	for <linux-unionfs@archiver.kernel.org>; Sun,  6 Mar 2022 05:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232902AbiCFFdw (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 6 Mar 2022 00:33:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiCFFdv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 6 Mar 2022 00:33:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082203DA57;
        Sat,  5 Mar 2022 21:32:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 829BB60FBE;
        Sun,  6 Mar 2022 05:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60900C340EF;
        Sun,  6 Mar 2022 05:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646544776;
        bh=UBl0Cn7SYsEWQP0mkjEP12HH7xWeNZim7VPPZ9aaiTE=;
        h=From:To:Cc:Subject:Date:From;
        b=Nf4TxnefPNULT2ZF3w48Nx7IyrXI5cg6baok7cswurLbnmnnvxlwM1h48wZmVZqsZ
         R7BGYtVkCdA6nOUw637GmAnQlhXlwvvKtg9NjL/U8AFj/y1qwytcUVhmH3ABo9g8LY
         ubG06ZdBvHGqJ25qOIPJdf9/zPqxaQVyGDLy1tcIywZuflGcW62KsH8VknB28YY2hS
         x9L/nacEEpqYzBOA3jynG83BWpGh7zSPw9a1x7ETRC74lUEJ2XlG2qQaXTnYvov+QK
         AH17RQQXWyUnxGpsz32x9Sp5z+wG7//6e1d5/zMAVW3hcSnQUhLJjXWAo+fa7vx3r1
         CtEqFjQJdNo6w==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-mm@kvack.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Nathaniel McCallum <nathaniel@profian.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Matthew Auld <matthew.auld@intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jason Ekstrand <jason@jlekstrand.net>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@suse.com>,
        zhangyiru <zhangyiru3@huawei.com>,
        Alexey Gladkov <legion@kernel.org>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        linux-mips@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, codalist@coda.cs.cmu.edu,
        linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH RFC 0/3] MAP_POPULATE for device memory
Date:   Sun,  6 Mar 2022 07:32:04 +0200
Message-Id: <20220306053211.135762-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

For device memory (aka VM_IO | VM_PFNMAP) MAP_POPULATE does nothing. Allow
to use that for initializing the device memory by providing a new callback
f_ops->populate() for the purpose.

SGX patches are provided to show the callback in context.

An obvious alternative is a ioctl but it is less elegant and requires
two syscalls (mmap + ioctl) per memory range, instead of just one
(mmap).

Jarkko Sakkinen (3):
  mm: Add f_ops->populate()
  x86/sgx: Export sgx_encl_page_alloc()
  x86/sgx: Implement EAUG population with MAP_POPULATE

 arch/mips/kernel/vdso.c                    |   2 +-
 arch/x86/kernel/cpu/sgx/driver.c           | 129 +++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/encl.c             |  38 ++++++
 arch/x86/kernel/cpu/sgx/encl.h             |   3 +
 arch/x86/kernel/cpu/sgx/ioctl.c            |  38 ------
 drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c |   2 +-
 fs/coda/file.c                             |   2 +-
 fs/overlayfs/file.c                        |   2 +-
 include/linux/fs.h                         |  12 +-
 include/linux/mm.h                         |   2 +-
 ipc/shm.c                                  |   2 +-
 mm/mmap.c                                  |  10 +-
 mm/nommu.c                                 |   4 +-
 13 files changed, 193 insertions(+), 53 deletions(-)

-- 
2.35.1

