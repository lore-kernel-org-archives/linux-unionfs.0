Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EED191F94
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Dec 2024 03:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733456115; cv=none; b=dcq9nY6guoFF4kT9rEp5apvmzFP0QTHUh8G2T9kYd8ToxxcQaiiln/ekEXHJkT6zjSjuSybfsWTMlFdqdsu3pfK2yPBBQSaxZIb/tOBFyWy3bWi463PQ6II7MkLfhER64KXeFz5Hpvdmyg7ab+NMARecFH4Sk/lDaQsYeWErUjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733456115; c=relaxed/simple;
	bh=IL2OPZNv5hXSWLlfwiTpqOkljnRShO138KHaHjoE1Ms=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Lurp3+nDDo3ifp/tuzQPkpz3eNZVSYIq+F1Verzsg7fTqzing4Y5L3rMKPjGE+2TcbZ2QxU7+/2JPWZq6BBvqv9dgwbbQBBK5a+CJzvSkv5T+zmzAVib51VmyMHYgNrockyO6JamOeJJQNj97qtxa5o7WE6L3B/hUkCs4I3IW6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Y4H2j5dBgz1yrnm;
	Fri,  6 Dec 2024 11:35:25 +0800 (CST)
Received: from dggpeml500011.china.huawei.com (unknown [7.185.36.84])
	by mail.maildlp.com (Postfix) with ESMTPS id CCEEA14011B;
	Fri,  6 Dec 2024 11:35:09 +0800 (CST)
Received: from [10.174.179.13] (10.174.179.13) by
 dggpeml500011.china.huawei.com (7.185.36.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 6 Dec 2024 11:35:09 +0800
Message-ID: <041dcc1a-0630-27b9-661b-8c64a3775426@huawei.com>
Date: Fri, 6 Dec 2024 11:35:08 +0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH -next] ovl: respect underlying filesystem's
 get_unmapped_area()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: <miklos@szeredi.hu>, <amir73il@gmail.com>, <akpm@linux-foundation.org>,
	<vbabka@suse.cz>, <jannh@google.com>, <linux-mm@kvack.org>,
	<linux-unionfs@vger.kernel.org>, <wangkefeng.wang@huawei.com>,
	<sunnanyong@huawei.com>, <yi.zhang@huawei.com>, <tujinjiang@huawei.com>,
	Matthew Wilcox <willy@infradead.org>
References: <20241205143038.3260233-1-tujinjiang@huawei.com>
 <69b72e3d-b101-4641-9ce5-51346c93a98d@lucifer.local>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <69b72e3d-b101-4641-9ce5-51346c93a98d@lucifer.local>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500011.china.huawei.com (7.185.36.84)


在 2024/12/5 23:04, Lorenzo Stoakes 写道:
> + Matthew for large folio aspect
>
> On Thu, Dec 05, 2024 at 10:30:38PM +0800, Jinjiang Tu wrote:
>> During our tests in containers, there is a read-only file (i.e., shared
>> libraies) in the overlayfs filesystem, and the underlying filesystem is
>> ext4, which supports large folio. We mmap the file with PROT_READ prot,
>> and then call madvise(MADV_COLLAPSE) for it. However, the madvise call
>> fails and returns EINVAL.
>>
>> The reason is that the mapping address isn't aligned to PMD size. Since
>> overlayfs doesn't support large folio, __get_unmapped_area() doesn't call
>> thp_get_unmapped_area() to get a THP aligned address.
>>
>> To fix it, call get_unmapped_area() with the realfile.
> Isn't the correct solution to get overlayfs to support large folios?
>
>> Besides, since overlayfs may be built with CONFIG_OVERLAY_FS=m, we should
>> export get_unmapped_area().
> Yeah, not in favour of this at all. This is an internal implementation
> detail. It seems like you're trying to hack your way into avoiding
> providing support for large folios and to hand it off to the underlying
> file system.
>
> Again, why don't you just support large folios in overlayfs?
>
> Literally no other file system or driver appears to make use of this
> directly in this manner.
>
> And there's absolutely no way this should be exported non-GPL as if it were
> unavoidable core functionality that everyone needs. Only you seem to...
>
>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
>> ---
>>   fs/overlayfs/file.c | 20 ++++++++++++++++++++
>>   mm/mmap.c           |  1 +
>>   2 files changed, 21 insertions(+)
>>
>> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
>> index 969b458100fe..d0dcf675ebe8 100644
>> --- a/fs/overlayfs/file.c
>> +++ b/fs/overlayfs/file.c
>> @@ -653,6 +653,25 @@ static int ovl_flush(struct file *file, fl_owner_t id)
>>   	return err;
>>   }
>>
>> +static unsigned long ovl_get_unmapped_area(struct file *file,
>> +		unsigned long addr, unsigned long len, unsigned long pgoff,
>> +		unsigned long flags)
>> +{
>> +	struct file *realfile;
>> +	const struct cred *old_cred;
>> +	unsigned long ret;
>> +
>> +	realfile = ovl_real_file(file);
>> +	if (IS_ERR(realfile))
>> +		return PTR_ERR(realfile);
>> +
>> +	old_cred = ovl_override_creds(file_inode(file)->i_sb);
>> +	ret = get_unmapped_area(realfile, addr, len, pgoff, flags);
>> +	ovl_revert_creds(old_cred);
> Why are you overriding credentials, then reinstating them here? That
> seems... iffy? I knew nothing about overlayfs so this may just be a
> misunderstanding...

I refer to other file operations in overlayfs (i.e., ovl_fallocate, backing_file_mmap).
Since get_unmapped_area() has security related operations (e.g., security_mmap_addr()),
We should call it with the cred of the underlying file.

>
>> +
>> +	return ret;
>> +}
>> +
>>   const struct file_operations ovl_file_operations = {
>>   	.open		= ovl_open,
>>   	.release	= ovl_release,
>> @@ -661,6 +680,7 @@ const struct file_operations ovl_file_operations = {
>>   	.write_iter	= ovl_write_iter,
>>   	.fsync		= ovl_fsync,
>>   	.mmap		= ovl_mmap,
>> +	.get_unmapped_area = ovl_get_unmapped_area,
>>   	.fallocate	= ovl_fallocate,
>>   	.fadvise	= ovl_fadvise,
>>   	.flush		= ovl_flush,
>> diff --git a/mm/mmap.c b/mm/mmap.c
>> index 16f8e8be01f8..60eb1ff7c9a8 100644
>> --- a/mm/mmap.c
>> +++ b/mm/mmap.c
>> @@ -913,6 +913,7 @@ __get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
>>   	error = security_mmap_addr(addr);
>>   	return error ? error : addr;
>>   }
>> +EXPORT_SYMBOL(__get_unmapped_area);
> We'll need a VERY good reason to export this internal implementation
> detail, and if that were provided we'd need a VERY good reason for it not
> to be GPL.
>
> This just seems to be a cheap way of invoking (),
> maybe, if it is being used by the underlying file system.

But the underlying file system may not support large folio. In this case,
the mmap address doesn't need to be aligned with THP size.

>
> And again... why not just add large folio support? We can't just take a
> hack here.
>
>>   unsigned long
>>   mm_get_unmapped_area(struct mm_struct *mm, struct file *file,
>> --
>> 2.34.1
>>
