Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BC622617C
	for <linux-unionfs@vger.kernel.org>; Tue, 10 Dec 2024 07:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733814554; cv=none; b=k4EY1lqLjkU0kIgPvdGo1CDJoFMOyjkb16kVJ33gymjJhu7Pf755x4W0oLc4e/KO8+cvfaIGYMQd1QCAzy53dktLMSPEwC1OjhBcWhTHGSe6MtAJh+FY/JriQL9KyKeX4LM0S5lB2rG0/NuVPFZTmfKu40UTZT97+A32ALkvII0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733814554; c=relaxed/simple;
	bh=mslyO4u2yaDHIvqu2u1BOW/2+mygShtJC2w8TjMMRac=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=JMOpEA1iabXI4W8cLRQ+oqmgpOR6fwVKIL3TOOTE28jbBaknNpdtjgQb483n/aGM1J7OSOoEe5OJsorilEcpcOq+AsuJcQhkFOYVNYb1NzvtR+rBBShuVIxH1UYh33BCQklYzWX0jxJXD3nzUOXCpzmYiK9IDq8Wu+y7EroYFC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Y6qYK5nBGzRhmG;
	Tue, 10 Dec 2024 15:07:17 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id A55431402E2;
	Tue, 10 Dec 2024 15:09:01 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 10 Dec 2024 15:09:01 +0800
Message-ID: <21f75d9e-dbe4-44d5-a3fc-65f6358bd429@huawei.com>
Date: Tue, 10 Dec 2024 15:09:00 +0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] ovl: respect underlying filesystem's
 get_unmapped_area()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Jinjiang Tu <tujinjiang@huawei.com>, <miklos@szeredi.hu>,
	<amir73il@gmail.com>, <akpm@linux-foundation.org>, <vbabka@suse.cz>,
	<jannh@google.com>, <linux-mm@kvack.org>, <linux-unionfs@vger.kernel.org>,
	<sunnanyong@huawei.com>, <yi.zhang@huawei.com>, Matthew Wilcox
	<willy@infradead.org>
References: <20241205143038.3260233-1-tujinjiang@huawei.com>
 <69b72e3d-b101-4641-9ce5-51346c93a98d@lucifer.local>
 <041dcc1a-0630-27b9-661b-8c64a3775426@huawei.com>
 <a39ef271-dc1b-4f61-ba01-dde5b127bef2@lucifer.local>
 <f2668332-78ac-4dc1-abcc-440e38964ccc@huawei.com>
 <a101ce9b-9789-4883-a232-056330642fd8@lucifer.local>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <a101ce9b-9789-4883-a232-056330642fd8@lucifer.local>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemf100008.china.huawei.com (7.185.36.138)



On 2024/12/6 19:53, Lorenzo Stoakes wrote:
> On Fri, Dec 06, 2024 at 06:45:11PM +0800, Kefeng Wang wrote:
>> So maybe use mm_get_unmapped_area() instead of __get_unmapped_area(),
>> something like below,
>>
>> +static unsigned long ovl_get_unmapped_area(struct file *file,
>> +               unsigned long addr, unsigned long len, unsigned long pgoff,
>> +               unsigned long flags)
>> +{
>> +       struct file *realfile;
>> +       const struct cred *old_cred;
>> +
>> +       realfile = ovl_real_file(file);
>> +       if (IS_ERR(realfile))
>> +               return PTR_ERR(realfile);
>> +
>> +       if (realfile->f_op->get_unmapped_area) {
>> +               unsigned long ret;
>> +
>> +               old_cred = ovl_override_creds(file_inode(file)->i_sb);
>> +               ret = realfile->f_op->get_unmapped_area(realfile, addr, len,
>> +                                                       pgoff, flags);
>> +               ovl_revert_creds(old_cred);
> 
> Credentials stuff necessary now you're not having security_mmap_addr()
> called etc.?

Not familiar with ovl, but we convert from file to realfile, adding cred
to prevent potential problems. maybe Amir could help to confirm it  :)

> 
>> +
>> +               if (ret)
>> +                       return ret;
> 
> Surely you'd unconditionally return in this case? I don't think there's any case
> where you'd want to fall through.

Yes, should directly return.

> 
>> +       }
>> +
>> +       return mm_get_unmapped_area(current->mm, file, addr, len, pgoff,
>> flags);
>> +}
>>
>> Correct me If I'm wrong.
>>
>> Thanks.
>>
> 
> I mean this doesn't export anything we don't want exported so this is fine
> from that perspective :)
> 
> And I guess in principle this is OK in that __get_unmapped_area() would be
> invoked on the overlay file, will do the required arch_mmap_check(), then
> will invoke your overlay handler.
> 
> I did think of suggesting invoking the f_op directly, but it feels icky
> vs. just supporting large folios.
> 
> But actually... hm I realise I overlooked the fact that underlying _files_
> will always provide a large folio-aware handler.
> 
> I'm guessing you can't use overlayfs somehow with a MAP_ANON | MAP_SHARED
> mapping or similar, thinking of:
> 
> 	if (file) {
> 		...
> 	} else if (flags & MAP_SHARED) {
> 		/*
> 		 * mmap_region() will call shmem_zero_setup() to create a file,
> 		 * so use shmem's get_unmapped_area in case it can be huge.
> 		 */
> 		get_area = shmem_get_unmapped_area;
> 	}
> 
> But surely actually any case that works with overlayfs will have a file and
> so... yeah.
> 
> Hm, I actually think this should work.
> 
> Can you make sure to do some pretty thorough testing on this just to make
> sure you're not hitting on any weirdness?
> 

Great, I thin Jinjiang could continue to this work.

