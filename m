Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4CE339AB
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Dec 2024 03:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733456126; cv=none; b=LDVTh+UfU60RfK1ERtf95D0BslcCqfF5sz7kGYj/5WtcciARih7W4BdWHvHly7ofC3kcoU5e0cP2jPgrVoNCvUG7hb/Ig2HxeKjzbMUoQgltDcecVIzWygXyQhUHvX4EsXu94Qteh5iQRvuTyLYrHd6I4kRdZ9DiFzAIVtBjqO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733456126; c=relaxed/simple;
	bh=ITQkhBde6RapiXyhCJTIYUhjdsjNnYbavxhARaGNqKU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=GvuEu6cHXQrTy7ocsD4K8i0Eu3AEhRP0zcrLccvG6PVsueiqPNSDnSl+4Bif+vdoQ8CG+x0nGPM0wYRZ9vnAfs8NkaWzP49YGWT715o+NyVtxBjkvJw1VjgzLnxYKPppwlotO048IWfK/mK0u3+pKiDAbP4Vwh1n1CiMZw0jN/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Y4H0k31xvz21mcR;
	Fri,  6 Dec 2024 11:33:42 +0800 (CST)
Received: from dggpeml500011.china.huawei.com (unknown [7.185.36.84])
	by mail.maildlp.com (Postfix) with ESMTPS id 902411A016C;
	Fri,  6 Dec 2024 11:35:21 +0800 (CST)
Received: from [10.174.179.13] (10.174.179.13) by
 dggpeml500011.china.huawei.com (7.185.36.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 6 Dec 2024 11:35:20 +0800
Message-ID: <518c881b-8ba0-df0e-16bf-00694c59f5a7@huawei.com>
Date: Fri, 6 Dec 2024 11:35:20 +0800
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
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Amir Goldstein
	<amir73il@gmail.com>
CC: <miklos@szeredi.hu>, <akpm@linux-foundation.org>, <vbabka@suse.cz>,
	<jannh@google.com>, <linux-mm@kvack.org>, <linux-unionfs@vger.kernel.org>,
	<wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>, <yi.zhang@huawei.com>,
	Matthew Wilcox <willy@infradead.org>, Liam Howlett <liam.howlett@oracle.com>
References: <20241205143038.3260233-1-tujinjiang@huawei.com>
 <69b72e3d-b101-4641-9ce5-51346c93a98d@lucifer.local>
 <CAOQ4uxjLZJXDm+7aiFsEtiUhvux5U=dftw7eNBpk55J6wW9XBw@mail.gmail.com>
 <f773da0d-38df-43ad-86a9-6cba785d53a8@lucifer.local>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <f773da0d-38df-43ad-86a9-6cba785d53a8@lucifer.local>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500011.china.huawei.com (7.185.36.84)


在 2024/12/5 23:24, Lorenzo Stoakes 写道:
> (fixing typo in cc list: tujinjiang@huawe.com -> tujinjiang@huawei.com)
>
> + Liam
>
> (JinJiang - you forgot to cc the correct maintainers, please ensure you run
> scripts/get_maintainers.pl on files you change)
>
> On Thu, Dec 05, 2024 at 04:12:12PM +0100, Amir Goldstein wrote:
>> On Thu, Dec 5, 2024 at 4:04 PM Lorenzo Stoakes
>> <lorenzo.stoakes@oracle.com> wrote:
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
>> This whole discussion seems moot.
>> overlayfs does not have address_space operations
>> It does not have its own page cache.
> And here we see my total lack of knowledge of overlayfs coming into play
> here :) Thanks for pointing this out.
>
> In that case, I object even further to the original of course...
>
>> The file in  vma->vm_file is not an overlayfs file at all - it is the
>> real (e.g. ext4) file
>> when returning from ovl_mmap() => backing_file_mmap()
>> so I have very little clue why the proposed solution even works,
>> but it certainly does not look correct.
> I think then Jinjiang in this cause you ought to go back to the drawing
> board and reconsider what might be the underlying issue here.

When usespace calls mmap syscall, the call trace is as follows:

do_mmap
   __get_unmapped_area
   mmap_region
     mmap_file
       ovl_mmap

__get_unmapped_area() gets the address to mmap at, the file here is an overlayfs file.
Since ovl_file_operations doesn't defines get_unmapped_area callback, __get_unmapped_area()
fallbacks to mm_get_unmapped_area_vmflags(), and it doesn't return an address aligned to
large folio size.

>
>> Thanks,
>> Amir.
> Cheers, Lorenzo
>
