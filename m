Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2301C22836E
	for <linux-unionfs@vger.kernel.org>; Tue, 10 Dec 2024 07:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733814808; cv=none; b=KvAe07vtEahi2gVam7wzmjal5OijdApywWctFbqfkuvTnN3xeXk9QO57YndvWvJm+DAGbYPTJGqmDRzteWrbVabwlFcbRy/roVQB9ACLdIcwqZJ4vi2PdvF/V0gTZRe9XBPmJD5GPKn4mHpUXIo80r1SE+U/P3UUBXCMc4RS8U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733814808; c=relaxed/simple;
	bh=jzI5rxPexKdznei5h/b2UcYnF80vzssvtJRemHMOrak=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=jKIhGa4eHXG8bKtsqmqImF+EXyqhZZLhSJFdt/vSFr/C6egRJnv8cfPHY1HQQyfShV4YlWOOwmkjzBzq5t1IrhOpskf7D2ZUan7s/uRnVEVZLEZ0r69QolkGdeTtFUtdfBD17sAfY5lKaO1AgoJgTrb/lHLW5HeQW0uOghJNaCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Y6qcp1ZB8z11MHf;
	Tue, 10 Dec 2024 15:10:18 +0800 (CST)
Received: from dggpeml500011.china.huawei.com (unknown [7.185.36.84])
	by mail.maildlp.com (Postfix) with ESMTPS id A014B14011B;
	Tue, 10 Dec 2024 15:13:22 +0800 (CST)
Received: from [10.174.179.13] (10.174.179.13) by
 dggpeml500011.china.huawei.com (7.185.36.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 10 Dec 2024 15:13:22 +0800
Message-ID: <30caaca6-df23-c1cc-1980-88b83600807f@huawei.com>
Date: Tue, 10 Dec 2024 15:13:21 +0800
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
To: Matthew Wilcox <willy@infradead.org>
CC: <miklos@szeredi.hu>, <amir73il@gmail.com>, <akpm@linux-foundation.org>,
	<lorenzo.stoakes@oracle.com>, <vbabka@suse.cz>, <jannh@google.com>,
	<linux-mm@kvack.org>, <linux-unionfs@vger.kernel.org>,
	<wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>, <yi.zhang@huawei.com>
References: <20241205143038.3260233-1-tujinjiang@huawei.com>
 <Z1MDIqKiyIdXTqji@casper.infradead.org>
 <4a8e2901-12b3-b700-383c-3193adc0ed60@huawei.com>
 <Z1bxqKIHreKySaGx@casper.infradead.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <Z1bxqKIHreKySaGx@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500011.china.huawei.com (7.185.36.84)


在 2024/12/9 21:33, Matthew Wilcox 写道:
> On Mon, Dec 09, 2024 at 02:43:08PM +0800, Jinjiang Tu wrote:
>> 在 2024/12/6 21:58, Matthew Wilcox 写道:
>>> On Thu, Dec 05, 2024 at 10:30:38PM +0800, Jinjiang Tu wrote:
>>>> During our tests in containers, there is a read-only file (i.e., shared
>>> Show your test.
>> I mmap an overlayfs file with PROT_READ, and call madvise(MADV_COLLAPSE), the code
>> is as follows:
>>
>> 	fd = open(path, O_RDONLY);
>> 	addr = mmap(NULL, size, PROT_READ, MAP_PRIVATE, fd, 0);
>> 	ret = madvise(addr, size, MADV_COLLAPSE);
>>
>> The addr isn't THP-aligned and ret is -1, errno is EINVAL.
> Then your test is buggy.
>
>           * Check alignment for file vma and size for both file and anon vma by
>           * filtering out the unsuitable orders.
>
> You didn't align your mmap, so it's expected to fail.

When mmap an ext4 file, since ext4_file_operations defines ".get_unmapped_area = thp_get_unmapped_area", it calls thp_get_unmapped_area() in __get_unmapped_area to
mmap at a THP-aligned address.

For overlayfs file, it's underlying filesystem may be ext4, which supports large folio. For this situation, should we mmap at a THP-aligned address too, to map
THP?

Thanks.

