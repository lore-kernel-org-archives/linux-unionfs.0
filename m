Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 049C8C433ED
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Apr 2021 12:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE402613F6
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Apr 2021 12:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236340AbhDVMrN convert rfc822-to-8bit (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 22 Apr 2021 08:47:13 -0400
Received: from hurricane.elijah.cs.cmu.edu ([128.2.209.191]:51008 "EHLO
        hurricane.elijah.cs.cmu.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236347AbhDVMrM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 22 Apr 2021 08:47:12 -0400
X-Greylist: delayed 1120 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Apr 2021 08:47:12 EDT
Received: from [72.95.139.242] (helo=[192.168.2.97])
        by hurricane.elijah.cs.cmu.edu with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <jaharkes@cs.cmu.edu>)
        id 1lZYR1-0000yX-4S; Thu, 22 Apr 2021 08:27:55 -0400
Date:   Thu, 22 Apr 2021 08:27:53 -0400
In-Reply-To: <20210421132012.82354-1-christian.koenig@amd.com>
References: <20210421132012.82354-1-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Autocrypt: addr=jaharkes@cs.cmu.edu; keydata=
 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
Subject: Re: [PATCH 1/2] coda: fix reference counting in coda_file_mmap error path
To:     =?ISO-8859-1?Q?Christian_K=F6nig?= 
        <ckoenig.leichtzumerken@gmail.com>, linux-kernel@vger.kernel.org,
        linux-unionfs@vger.kernel.org, dri-devel@lists.freedesktop.org
CC:     coda@cs.cmu.edu, miklos@szeredi.hu, akpm@linux-foundation.org,
        jgg@ziepe.ca
From:   Jan Harkes <jaharkes@cs.cmu.edu>
Message-ID: <91292A4A-5F97-4FF8-ABAD-42392A0756B5@cs.cmu.edu>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Looks good to me.

I'm also maintaining an out of tree coda module build that people sometimes use, which has workarounds for differences between the various kernel versions.

Do you have a reference to the corresponding mmap_region change? If it is merged already I'll probably be able to find it. Is this mmap_region change expected to be backported to any lts kernels?

Jan

On April 21, 2021 9:20:11 AM EDT, "Christian König" <ckoenig.leichtzumerken@gmail.com> wrote:
>mmap_region() now calls fput() on the vma->vm_file.
>
>So we need to drop the extra reference on the coda file instead of the
>host file.
>
>Signed-off-by: Christian König <christian.koenig@amd.com>
>Fixes: 1527f926fd04 ("mm: mmap: fix fput in error path v2")
>CC: stable@vger.kernel.org # 5.11+
>---
> fs/coda/file.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>
>diff --git a/fs/coda/file.c b/fs/coda/file.c
>index 128d63df5bfb..ef5ca22bfb3e 100644
>--- a/fs/coda/file.c
>+++ b/fs/coda/file.c
>@@ -175,10 +175,10 @@ coda_file_mmap(struct file *coda_file, struct
>vm_area_struct *vma)
> 	ret = call_mmap(vma->vm_file, vma);
> 
> 	if (ret) {
>-		/* if call_mmap fails, our caller will put coda_file so we
>-		 * should drop the reference to the host_file that we got.
>+		/* if call_mmap fails, our caller will put host_file so we
>+		 * should drop the reference to the coda_file that we got.
> 		 */
>-		fput(host_file);
>+		fput(coda_file);
> 		kfree(cvm_ops);
> 	} else {
> 		/* here we add redirects for the open/close vm_operations */
