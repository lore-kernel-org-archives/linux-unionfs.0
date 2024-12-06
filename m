Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E451FBC8A
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Dec 2024 10:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733481919; cv=none; b=PobRYCALPCdZU42CFUlE/muNsaiOrrmSwDVQvukk0JsyaE1mcqGwvr4aBaBmlo6UhG9tF8gTWrP48CjoBBDX4EOmz3ishlRIjCabd0eZ8zRlYjvZl2m954wq5M8tdV7rTGUoqjDT/4dNIydH6kITuJsNssjniRJjaSKNHeBPTvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733481919; c=relaxed/simple;
	bh=UaeWcib9EduSkGUZY88l8f4BlJ3E76RciSgSePP2gUA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Xoi2x+8UBHI6bKeUUOgT+GDEzV/hDm0FXaITxk7SUtk5RooAXjs96dbfUSTFyCpZt0x8R/+UKAg0MTFiUrQjLtxMNg5ZGut8PR4KMZkO8DZYAOJVG1yZu12DFZYSYiupFJstuEyPaVd+3suBzb2C8CL0SE+dGa0Dpr2cyWkROMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Y4SW94n7bz1V5jT;
	Fri,  6 Dec 2024 18:42:13 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id C19EE1402E0;
	Fri,  6 Dec 2024 18:45:12 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 6 Dec 2024 18:45:12 +0800
Message-ID: <f2668332-78ac-4dc1-abcc-440e38964ccc@huawei.com>
Date: Fri, 6 Dec 2024 18:45:11 +0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] ovl: respect underlying filesystem's
 get_unmapped_area()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Jinjiang Tu
	<tujinjiang@huawei.com>
CC: <miklos@szeredi.hu>, <amir73il@gmail.com>, <akpm@linux-foundation.org>,
	<vbabka@suse.cz>, <jannh@google.com>, <linux-mm@kvack.org>,
	<linux-unionfs@vger.kernel.org>, <sunnanyong@huawei.com>,
	<yi.zhang@huawei.com>, Matthew Wilcox <willy@infradead.org>
References: <20241205143038.3260233-1-tujinjiang@huawei.com>
 <69b72e3d-b101-4641-9ce5-51346c93a98d@lucifer.local>
 <041dcc1a-0630-27b9-661b-8c64a3775426@huawei.com>
 <a39ef271-dc1b-4f61-ba01-dde5b127bef2@lucifer.local>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <a39ef271-dc1b-4f61-ba01-dde5b127bef2@lucifer.local>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemf100008.china.huawei.com (7.185.36.138)



On 2024/12/6 17:25, Lorenzo Stoakes wrote:
> To be clear - I'm not accepting the export of __get_unmapped_area() so if
> you depend on this for this approach, you can't take this approach.
> 
> It's an internal implementation detail. That you choose to make your
> filesystem possibly a module doesn't mean that mm is required to export
> internal impl details to you. Sorry.
> 
> To rescind this would require a very strong argument, you have not provided
> it.
> 
> On Fri, Dec 06, 2024 at 11:35:08AM +0800, Jinjiang Tu wrote:
>>
>> 在 2024/12/5 23:04, Lorenzo Stoakes 写道:
>>> + Matthew for large folio aspect
>>>
>>> On Thu, Dec 05, 2024 at 10:30:38PM +0800, Jinjiang Tu wrote:
>>>> During our tests in containers, there is a read-only file (i.e., shared
>>>> libraies) in the overlayfs filesystem, and the underlying filesystem is
>>>> ext4, which supports large folio. We mmap the file with PROT_READ prot,
>>>> and then call madvise(MADV_COLLAPSE) for it. However, the madvise call
>>>> fails and returns EINVAL.
>>>>
>>>> The reason is that the mapping address isn't aligned to PMD size. Since
>>>> overlayfs doesn't support large folio, __get_unmapped_area() doesn't call
>>>> thp_get_unmapped_area() to get a THP aligned address.
>>>>
>>>> To fix it, call get_unmapped_area() with the realfile.
>>> Isn't the correct solution to get overlayfs to support large folios?
>>>
>>>> Besides, since overlayfs may be built with CONFIG_OVERLAY_FS=m, we should
>>>> export get_unmapped_area().
>>> Yeah, not in favour of this at all. This is an internal implementation
>>> detail. It seems like you're trying to hack your way into avoiding
>>> providing support for large folios and to hand it off to the underlying
>>> file system.
>>>
>>> Again, why don't you just support large folios in overlayfs?
>>>
>>> Literally no other file system or driver appears to make use of this
>>> directly in this manner.
>>>
>>> And there's absolutely no way this should be exported non-GPL as if it were
>>> unavoidable core functionality that everyone needs. Only you seem to...
>>>
>>>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
>>>> ---
>>>>    fs/overlayfs/file.c | 20 ++++++++++++++++++++
>>>>    mm/mmap.c           |  1 +
>>>>    2 files changed, 21 insertions(+)
>>>>
>>>> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
>>>> index 969b458100fe..d0dcf675ebe8 100644
>>>> --- a/fs/overlayfs/file.c
>>>> +++ b/fs/overlayfs/file.c
>>>> @@ -653,6 +653,25 @@ static int ovl_flush(struct file *file, fl_owner_t id)
>>>>    	return err;
>>>>    }
>>>>
>>>> +static unsigned long ovl_get_unmapped_area(struct file *file,
>>>> +		unsigned long addr, unsigned long len, unsigned long pgoff,
>>>> +		unsigned long flags)
>>>> +{
>>>> +	struct file *realfile;
>>>> +	const struct cred *old_cred;
>>>> +	unsigned long ret;
>>>> +
>>>> +	realfile = ovl_real_file(file);
>>>> +	if (IS_ERR(realfile))
>>>> +		return PTR_ERR(realfile);
>>>> +
>>>> +	old_cred = ovl_override_creds(file_inode(file)->i_sb);
>>>> +	ret = get_unmapped_area(realfile, addr, len, pgoff, flags);
>>>> +	ovl_revert_creds(old_cred);
>>> Why are you overriding credentials, then reinstating them here? That
>>> seems... iffy? I knew nothing about overlayfs so this may just be a
>>> misunderstanding...
>>
>> I refer to other file operations in overlayfs (i.e., ovl_fallocate, backing_file_mmap).
>> Since get_unmapped_area() has security related operations (e.g., security_mmap_addr()),
>> We should call it with the cred of the underlying file.
>>
>>>
>>>> +
>>>> +	return ret;
>>>> +}
>>>> +
>>>>    const struct file_operations ovl_file_operations = {
>>>>    	.open		= ovl_open,
>>>>    	.release	= ovl_release,
>>>> @@ -661,6 +680,7 @@ const struct file_operations ovl_file_operations = {
>>>>    	.write_iter	= ovl_write_iter,
>>>>    	.fsync		= ovl_fsync,
>>>>    	.mmap		= ovl_mmap,
>>>> +	.get_unmapped_area = ovl_get_unmapped_area,
>>>>    	.fallocate	= ovl_fallocate,
>>>>    	.fadvise	= ovl_fadvise,
>>>>    	.flush		= ovl_flush,
>>>> diff --git a/mm/mmap.c b/mm/mmap.c
>>>> index 16f8e8be01f8..60eb1ff7c9a8 100644
>>>> --- a/mm/mmap.c
>>>> +++ b/mm/mmap.c
>>>> @@ -913,6 +913,7 @@ __get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
>>>>    	error = security_mmap_addr(addr);
>>>>    	return error ? error : addr;
>>>>    }
>>>> +EXPORT_SYMBOL(__get_unmapped_area);
>>> We'll need a VERY good reason to export this internal implementation
>>> detail, and if that were provided we'd need a VERY good reason for it not
>>> to be GPL.
>>>
>>> This just seems to be a cheap way of invoking (),
>>> maybe, if it is being used by the underlying file system.
>>
>> But the underlying file system may not support large folio. In this case,
>> the mmap address doesn't need to be aligned with THP size.
> 
> But it'd not cause any problems to just do that anyway right? I don't think
> many people think 'oh no I have a PMD aligned mapping now what will I do'?
> 
> Again - the right solution here is to handle large folios in overlayfs as
> far as I can tell.

I think this is not to handle large folio for overlayfs, it is about vma
alignment or vma allocation for memory mapped files,


1) many fs support THP mapping, using thp_get_unmapped_area(),

fs/bcachefs/fs.c:       .get_unmapped_area = thp_get_unmapped_area,
fs/btrfs/file.c:        .get_unmapped_area = thp_get_unmapped_area,
fs/erofs/data.c:        .get_unmapped_area = thp_get_unmapped_area,
fs/ext2/file.c: .get_unmapped_area = thp_get_unmapped_area,
fs/ext4/file.c: .get_unmapped_area = thp_get_unmapped_area,
fs/fuse/file.c: .get_unmapped_area = thp_get_unmapped_area,
fs/xfs/xfs_file.c:      .get_unmapped_area = thp_get_unmapped_area,

2) and some fs has own get_unmapped_area callback too,

fs/cramfs/inode.c:	.get_unmapped_area	= cramfs_physmem_get_unmapped_area,
fs/hugetlbfs/inode.c:	.get_unmapped_area	= hugetlb_get_unmapped_area,
fs/ramfs/file-mmu.c:	.get_unmapped_area	= ramfs_mmu_get_unmapped_area,
fs/ramfs/file-nommu.c:	.get_unmapped_area	= ramfs_nommu_get_unmapped_area,
fs/romfs/mmap-nommu.c:	.get_unmapped_area	= romfs_get_unmapped_area,
mm/shmem.c:	.get_unmapped_area = shmem_get_unmapped_area,

They has own rules to get a vma area, but with overlayfs(tries to
present a filesystem which is the result over overlaying one filesystem
on top of the other), we now only use the default
mm_get_unmapped_area_vmflags() to get a vma area, since the overlayfs
has no '.get_unmapped_area' callback.

do_mmap
   __get_unmapped_area
     // get_area = NULL
     mm_get_unmapped_area_vmflags
   mmap_region
     mmap_file
       ovl_mmap

It looks wrong, so we need to get the readfile via ovl_real_file()
and use realfile' get_unmapped_area callback, and if the realfile
is not with the callback, fallback to the default
mm_get_unmapped_area(),

> 
> In any case as per the above, we're just not exporting
> __get_unmapped_area(), sorry.
> 

So maybe use mm_get_unmapped_area() instead of __get_unmapped_area(),
something like below,

+static unsigned long ovl_get_unmapped_area(struct file *file,
+               unsigned long addr, unsigned long len, unsigned long pgoff,
+               unsigned long flags)
+{
+       struct file *realfile;
+       const struct cred *old_cred;
+
+       realfile = ovl_real_file(file);
+       if (IS_ERR(realfile))
+               return PTR_ERR(realfile);
+
+       if (realfile->f_op->get_unmapped_area) {
+               unsigned long ret;
+
+               old_cred = ovl_override_creds(file_inode(file)->i_sb);
+               ret = realfile->f_op->get_unmapped_area(realfile, addr, len,
+                                                       pgoff, flags);
+               ovl_revert_creds(old_cred);
+
+               if (ret)
+                       return ret;
+       }
+
+       return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, 
flags);
+}

Correct me If I'm wrong.

Thanks.


>>
>>>
>>> And again... why not just add large folio support? We can't just take a
>>> hack here.
>>>
>>>>    unsigned long
>>>>    mm_get_unmapped_area(struct mm_struct *mm, struct file *file,
>>>> --
>>>> 2.34.1
>>>>
> 

