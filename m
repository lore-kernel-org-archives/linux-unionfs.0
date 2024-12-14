Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D2C1CD2C
	for <linux-unionfs@vger.kernel.org>; Sat, 14 Dec 2024 07:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734163125; cv=none; b=PpPAy9d+ErJ8GzpJgexTGPp2VaJ8fC0m1yWfZJJHp0fI9Itc0ALD8A9b65taYNoHVtyxOwE8cl6Y6xJkYxc4cPsOS+hwkstmXriFgJcXVZdmT8+MeBlCkDe8/FxE2VckCBOj6hZDFBMYQtYLDeB4HOSrboW7hr9sBZ+vSeihyVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734163125; c=relaxed/simple;
	bh=+8ktIOdah+YAMqnhPRVRsZ6bNLmLRv2MYvYR99TU6vA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=OzpKY2fB4CXY9CfSpZSWph35QAIoHoG1doDnfboPZdsQKYR1mH04rFgSVhnPK66pKKfFckb3tUcU2QGNi9Wo+VwTt2nlNcKJrHNrZDBjmC3J3dPDoSvO3sV6hF8Ojx7IfzsxA1VZbtWqhUZceA2ALQqk4lhDLz/7YYwAY+DpuKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Y9JSV6tXvzRj36;
	Sat, 14 Dec 2024 15:56:42 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 2F9E718009B;
	Sat, 14 Dec 2024 15:58:31 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 14 Dec 2024 15:58:30 +0800
Message-ID: <b9e1736f-aa1a-4661-874e-2ced295c7195@huawei.com>
Date: Sat, 14 Dec 2024 15:58:30 +0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] ovl: respect underlying filesystem's
 get_unmapped_area()
To: Matthew Wilcox <willy@infradead.org>
CC: Amir Goldstein <amir73il@gmail.com>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, Jinjiang Tu <tujinjiang@huawei.com>,
	<miklos@szeredi.hu>, <akpm@linux-foundation.org>, <vbabka@suse.cz>,
	<jannh@google.com>, <linux-mm@kvack.org>, <linux-unionfs@vger.kernel.org>,
	<sunnanyong@huawei.com>, <yi.zhang@huawei.com>
References: <20241205143038.3260233-1-tujinjiang@huawei.com>
 <69b72e3d-b101-4641-9ce5-51346c93a98d@lucifer.local>
 <041dcc1a-0630-27b9-661b-8c64a3775426@huawei.com>
 <a39ef271-dc1b-4f61-ba01-dde5b127bef2@lucifer.local>
 <f2668332-78ac-4dc1-abcc-440e38964ccc@huawei.com>
 <CAOQ4uxh5azF6As6TvV2eCKpnbct0-vNwJLTAwSiKc6QjK5TUBw@mail.gmail.com>
 <568698a0-c2f2-45d8-9d8b-e22e942fa422@huawei.com>
 <CAOQ4uxjBB7EUOnHB2n9BUGJ_TrHqvqJLksVyxcnpOUCR+7Tfyg@mail.gmail.com>
 <Z1u3S90PJL46-79U@casper.infradead.org>
 <3207edaf-826b-4545-9c9d-906bfb4d312e@huawei.com>
 <Z1w9_xGpHr04QtEw@casper.infradead.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <Z1w9_xGpHr04QtEw@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemf100008.china.huawei.com (7.185.36.138)



On 2024/12/13 22:00, Matthew Wilcox wrote:
> On Fri, Dec 13, 2024 at 03:49:53PM +0800, Kefeng Wang wrote:
>>
>>
>> On 2024/12/13 12:25, Matthew Wilcox wrote:
>>> On Wed, Dec 11, 2024 at 10:43:46AM +0100, Amir Goldstein wrote:
>>>> I think this patch is fine as is.
>>>
>>> This patch is complete crap.  The test-case is broken.  NAK to all of
>>> this.
>>>
>> Hi Matthew, regardless of the test case, the original issue is the
>> ovl don't respect underlying fs' get_unmapped_area(), the lower fs may
>> have own rules for vma alignment(own get_unmapped_area callback),
>> thp_get_unmapped_area() is one case, what's your option/suggestion about
> 
> No, filesystems don't "have their own rules" for get_unmapped_area.
> get_unmapped_area is for device drivers.


Commit 74d2fad1334d ("thp, dax: add thp_get_unmapped_area for pmd
mappings") to enable PMD mappings as a FSDAX filesystem, and with
commit 1854bc6e2420 ("mm/readahead: Align file mappings for non-DAX")
to enable THPs for mmapped files too, also other filesystem, eg,
tmpfs provide a shmem_get_unmapped_area to decide the mapping address,
see commit c01d5b300774 ("shmem: get_unmapped_area align huge page"),
that is what I think the filesystem have own rules to get the mapping
address, correct me if I misunderstood, thanks.
