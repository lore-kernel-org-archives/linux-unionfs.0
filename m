Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72F11FCCE6
	for <linux-unionfs@vger.kernel.org>; Tue, 10 Dec 2024 07:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733815197; cv=none; b=XV1TIrM3RL/RtRShAkOwz9DjM2cfES6Hg/jq9jJrpqk889XefR4hyIf16AtHXQOxthiiq4RoM2UbbGEieMXMZ2tojgHbY3ElwBnMHvaKtZ562Mtb3G+DwfLqxYgkI5iZy24f6JeHX83O9+aOCGh4Vm+uDV+0hsAyBVRDlgqc+jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733815197; c=relaxed/simple;
	bh=IwgcKMAYT3V5B+jmzBMLXpITaukgNQpJnp7SetugIQo=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=SjOG0CltAiXO8pllIm61/TKC/7nSSx/qWdNtjrvR4Vy/WWczL/8n4SC8Aelcd2Cpa+5XL6DkzJ01DyWw1SL6LPGSVz7a8tHJ/TIuPmsfS3KbZmJhHQgkqTnUnhe02TZIS8vuE/cQ5ySY7/N/XWjGAwIxStu3VvKA3RajXP+If/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Y6qn41CmBz1kvhH;
	Tue, 10 Dec 2024 15:17:28 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 51FAF140136;
	Tue, 10 Dec 2024 15:19:52 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 10 Dec 2024 15:19:51 +0800
Message-ID: <568698a0-c2f2-45d8-9d8b-e22e942fa422@huawei.com>
Date: Tue, 10 Dec 2024 15:19:51 +0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: Re: [PATCH -next] ovl: respect underlying filesystem's
 get_unmapped_area()
To: Amir Goldstein <amir73il@gmail.com>
CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Jinjiang Tu
	<tujinjiang@huawei.com>, <miklos@szeredi.hu>, <akpm@linux-foundation.org>,
	<vbabka@suse.cz>, <jannh@google.com>, <linux-mm@kvack.org>,
	<linux-unionfs@vger.kernel.org>, <sunnanyong@huawei.com>,
	<yi.zhang@huawei.com>, Matthew Wilcox <willy@infradead.org>
References: <20241205143038.3260233-1-tujinjiang@huawei.com>
 <69b72e3d-b101-4641-9ce5-51346c93a98d@lucifer.local>
 <041dcc1a-0630-27b9-661b-8c64a3775426@huawei.com>
 <a39ef271-dc1b-4f61-ba01-dde5b127bef2@lucifer.local>
 <f2668332-78ac-4dc1-abcc-440e38964ccc@huawei.com>
 <CAOQ4uxh5azF6As6TvV2eCKpnbct0-vNwJLTAwSiKc6QjK5TUBw@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAOQ4uxh5azF6As6TvV2eCKpnbct0-vNwJLTAwSiKc6QjK5TUBw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemf100008.china.huawei.com (7.185.36.138)



On 2024/12/6 20:58, Amir Goldstein wrote:
> On Fri, Dec 6, 2024 at 11:45 AM Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
>>
...
>>
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
>> +
>> +               if (ret)
>> +                       return ret;
>> +       }
>> +
>> +       return mm_get_unmapped_area(current->mm, file, addr, len, pgoff,
>> flags);
>> +}
>>
>> Correct me If I'm wrong.
>>
> 
> You just need to be aware of the fact that between ovl_get_unmapped_area()
> and ovl_mmap(), ovl_real_file(file) could change from the lower file, to the
> upper file due to another operation that initiated copy-up.

Not sure about this part(I have very little knowledge of ovl), do you
mean that we could not use ovl_real_file()?  The ovl_mmap() using
realfile = file->private_data, we may use similar way in
ovl_get_unmapped_area(). but I may have misunderstood.

Thanks.
