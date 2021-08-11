Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06E79C4338F
	for <linux-unionfs@archiver.kernel.org>; Wed, 11 Aug 2021 14:45:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBBB360E93
	for <linux-unionfs@archiver.kernel.org>; Wed, 11 Aug 2021 14:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbhHKOpn (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 11 Aug 2021 10:45:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46232 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232494AbhHKOpn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 11 Aug 2021 10:45:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628693119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eBcHxr3b5mworuPq4PqU+l4xARfNUKjm75tM9rIDjPo=;
        b=UlgKGqKA0XquDA7M45NOqhQMsgB9qaigBwu6Anbb8NYMBwvSK0AcVA4z3WpvfKqnndGvV/
        y7fEbdUbVTnku6JFk01Eb13tvpqQCpfGrIEIQz+wzgc/EOZn1YqUahv3mus54L7yU2ifdU
        wfZImY07Ec17H1YfCH77YhhwSemmlGM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-7WeCJHsWN5GIhRPTtYA2Dw-1; Wed, 11 Aug 2021 10:45:17 -0400
X-MC-Unique: 7WeCJHsWN5GIhRPTtYA2Dw-1
Received: by mail-wr1-f71.google.com with SMTP id n10-20020a5d660a0000b02901551ef5616eso309136wru.20
        for <linux-unionfs@vger.kernel.org>; Wed, 11 Aug 2021 07:45:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=eBcHxr3b5mworuPq4PqU+l4xARfNUKjm75tM9rIDjPo=;
        b=VDVRajxSWnEx/LvKiHJov2blWek6M1JFMZ/FujK+k/O47KSK7SlnXt5/p3ZrEEWhbM
         vfStvbS6aub5nHMO/tIXiASdUfivEQGzOuBGbibpuyt834PxUw7uKQzfVEAunJGy10F0
         BR04iweC/Il5m4lbbEz4CSrJ8m7K5aV5JOmx8uUPoRGVTPj88QQmAQTZ7hsu0+O23U8M
         9RvJGn5Am78kYKX3dlgmCVqoEixjfjtbrEBvHiHVc3wpzzJFx75cG2xEl51+i5Yu5gRZ
         Nm6q/ifyQkzBEBemyTbkZAkg0C6Vi1QWaQTs8LZDWPC/9gKneGq2lS3PI00lihWsEanP
         0qaw==
X-Gm-Message-State: AOAM533MwLADzAA3cyo3fvPvH9WWfNhR8KDXUpeGSURo+tDnt+0mHNUJ
        2ItixQ9kDsdo+W1yPeFTePdkzK89BvCLA0DE0+trsDbwEXH9cM5R7i5At4svWuyFJ0ece4LK+XZ
        UE+kdPk0NM2Z53lNHxzImlhEaz1VDrUTny+xwSBYcXNxBN0lBy2RBxWlBsF639E8cM/jotmKgaA
        ==
X-Received: by 2002:a1c:f019:: with SMTP id a25mr10501116wmb.96.1628693116115;
        Wed, 11 Aug 2021 07:45:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyH29GuiTfEW6pGrDbGgwByHckYOSWZlO1OckR66NtZ86Hv7seISYduYOnbWzd/HniZiX+U4w==
X-Received: by 2002:a1c:f019:: with SMTP id a25mr10501089wmb.96.1628693115840;
        Wed, 11 Aug 2021 07:45:15 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c64a0.dip0.t-ipconnect.de. [91.12.100.160])
        by smtp.gmail.com with ESMTPSA id g6sm9982769wrm.73.2021.08.11.07.45.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 07:45:14 -0700 (PDT)
Subject: Re: mmap denywrite mess (Was: [GIT PULL] overlayfs fixes for
 5.14-rc6)
To:     Miklos Szeredi <miklos@szeredi.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        Matthew Wilcox <willy@infradead.org>,
        linux-mm <linux-mm@kvack.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
References: <YRPaodsBm3ambw8z@miu.piliscsaba.redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <c13de127-a7f0-c2c3-cb21-24fce2c90c11@redhat.com>
Date:   Wed, 11 Aug 2021 16:45:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YRPaodsBm3ambw8z@miu.piliscsaba.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 11.08.21 16:11, Miklos Szeredi wrote:
> On Mon, Aug 09, 2021 at 02:25:17PM -0700, Linus Torvalds wrote:
> 
>> Ugh. Th edances with denywrite and mapping_unmap_writable are really
>> really annoying.
> 
> Attached version has error and success paths separated.  Was that your
> complaint?
> 
>> I get the feeling that the whole thing with deny_write_access and
>> mapping_map_writable could possibly be done after-the-fact somehow as
>> part of actually inserting the vma in the vma tree, rather than done
>> as the vma is prepared.
> 
> I don't know if that's doable or not.  The final denywrite count is obtained in
> __vma_link_file(), called after __vma_link().  The questions are:
> 
>   - does the order of those helper calls matter?
> 
>   - if it does, could the __vma_link() be safely undone after an unsuccessful
>     __vmal_link_file()?
> 
>> And most users of vma_set_file() probably really don't want that whole
>> thing at all (ie the DRM stuff that just switches out a local thing.
>> They also don't check for the new error cases you've added.
> 
> Christian König wants to follow up with those checks (which should be asserts,
> if the code wasn't buggy in the first place).
> 
>> So I really think this is quite questionable, and those cases should
>> probably have been done entirely inside ovlfs rather than polluting
>> the cases that don't care and don't check.
> 
> I don't get that.  mmap_region() currently drops the deny counts from the
> original file.  That doesn't work for overlayfs since it needs to take new temp
> counts on the override file.
> 
> So mmap_region() is changed to drop the counts on vma->vm_file, but then all
> callers of vma_set_file() will need to do that switch of temp counts, there's no
> way around that.
> 
> Thanks,
> Miklos
> 
> For reference, here's the previous discussion:
> 
> https://lore.kernel.org/linux-mm/YNHXzBgzRrZu1MrD@miu.piliscsaba.redhat.com/
> 
> ---
>   fs/overlayfs/file.c |    4 +++-
>   include/linux/mm.h  |    2 +-
>   mm/mmap.c           |    2 +-
>   mm/util.c           |   31 ++++++++++++++++++++++++++++++-
>   4 files changed, 35 insertions(+), 4 deletions(-)
> 
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -475,7 +475,9 @@ static int ovl_mmap(struct file *file, s
>   	if (WARN_ON(file != vma->vm_file))
>   		return -EIO;
>   
> -	vma_set_file(vma, realfile);
> +	ret = vma_set_file(vma, realfile);
> +	if (ret)
> +		return ret;
>   
>   	old_cred = ovl_override_creds(file_inode(file)->i_sb);
>   	ret = call_mmap(vma->vm_file, vma);
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2780,7 +2780,7 @@ static inline void vma_set_page_prot(str
>   }
>   #endif
>   
> -void vma_set_file(struct vm_area_struct *vma, struct file *file);
> +int /* __must_check */ vma_set_file(struct vm_area_struct *vma, struct file *file);
>   
>   #ifdef CONFIG_NUMA_BALANCING
>   unsigned long change_prot_numa(struct vm_area_struct *vma,
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1806,6 +1806,7 @@ unsigned long mmap_region(struct file *f
>   		 */
>   		vma->vm_file = get_file(file);
>   		error = call_mmap(file, vma);
> +		file = vma->vm_file;
>   		if (error)
>   			goto unmap_and_free_vma;
>   
> @@ -1867,7 +1868,6 @@ unsigned long mmap_region(struct file *f
>   		if (vm_flags & VM_DENYWRITE)
>   			allow_write_access(file);
>   	}
> -	file = vma->vm_file;
>   out:
>   	perf_event_mmap(vma);
>   
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -314,12 +314,41 @@ int vma_is_stack_for_current(struct vm_a
>   /*
>    * Change backing file, only valid to use during initial VMA setup.
>    */
> -void vma_set_file(struct vm_area_struct *vma, struct file *file)
> +int vma_set_file(struct vm_area_struct *vma, struct file *file)
>   {
> +	vm_flags_t vm_flags = vma->vm_flags;
> +	int err;
> +
> +	/* Get temporary denial counts on replacement */
> +	if (vm_flags & VM_DENYWRITE) {
> +		err = deny_write_access(file);
> +		if (err)
> +			return err;
> +	}
> +	if (vm_flags & VM_SHARED) {
> +		err = mapping_map_writable(file->f_mapping);
> +		if (err)
> +			goto undo_denywrite;
> +	}
> +
>   	/* Changing an anonymous vma with this is illegal */
>   	get_file(file);
>   	swap(vma->vm_file, file);
> +
> +	/* Undo temporary denial counts on replaced */
> +	if (vm_flags & VM_SHARED)
> +		mapping_unmap_writable(file->f_mapping);
> +
> +	if (vm_flags & VM_DENYWRITE)
> +		allow_write_access(file);
> +
>   	fput(file);
> +	return 0;
> +
> +undo_denywrite:
> +	if (vm_flags & VM_DENYWRITE)
> +		allow_write_access(file);
> +	return err;
>   }
>   EXPORT_SYMBOL(vma_set_file);
>   
> 

I proposed a while ago to get rid of VM_DENYWRITE completely:

https://lkml.kernel.org/r/20210423131640.20080-1-david@redhat.com

I haven't looked how much it still applies to current upstream, but 
maybe that might help cleaning up that code.

-- 
Thanks,

David / dhildenb

