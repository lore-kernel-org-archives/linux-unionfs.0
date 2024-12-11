Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785EE18EAD
	for <linux-unionfs@vger.kernel.org>; Wed, 11 Dec 2024 02:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733883677; cv=none; b=nyTXt63Ut5yEyo1RikAmp8rclkI7LvZU8SduZSeyVJcu/Sir5GcQolP3Ikn+qGIgXlHDaSto+LSdWz0mFsRkLFmLlQwNFksB6VBXya6Y8WKo7CnslV/sZGHWmFtjXr5wbQUxAvJqqjjYQFkIofjsFR02kgTFkRbR5go6zdt0d8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733883677; c=relaxed/simple;
	bh=RQER7QVpLFmvrLQTP4wpkSS+yQFCokkOw1IYo/9o1BU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F6qiC9dAKkOnODcYW5mo4K2fcNK/1H98aNMs2Vfd/w9wcIT6eycy+FasSYBXNj+/x9GgVgXJdRoQ4f+NDMIpPbRmPAGMQbLbHyq3JbN+oABI8AVCOdBsHc5DBAeDEPaBoul1Xd18GnT5vuZaBs/ypxXRpVwcFco79jATxgy5Yds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Y7K8L1qKPz4f3lDK
	for <linux-unionfs@vger.kernel.org>; Wed, 11 Dec 2024 10:20:50 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 825B11A0568
	for <linux-unionfs@vger.kernel.org>; Wed, 11 Dec 2024 10:21:10 +0800 (CST)
Received: from [10.174.179.80] (unknown [10.174.179.80])
	by APP4 (Coremail) with SMTP id gCh0CgBHIoYT91hnOzoHEQ--.51391S3;
	Wed, 11 Dec 2024 10:21:09 +0800 (CST)
Message-ID: <89ef2543-7373-455b-83bb-c3d51afe9386@huaweicloud.com>
Date: Wed, 11 Dec 2024 10:21:07 +0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] ovl: respect underlying filesystem's
 get_unmapped_area()
To: Matthew Wilcox <willy@infradead.org>, Jinjiang Tu <tujinjiang@huawei.com>
Cc: miklos@szeredi.hu, amir73il@gmail.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, vbabka@suse.cz, jannh@google.com,
 linux-mm@kvack.org, linux-unionfs@vger.kernel.org,
 wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
 Zhang Yi <yi.zhang@huawei.com>
References: <20241205143038.3260233-1-tujinjiang@huawei.com>
 <Z1MDIqKiyIdXTqji@casper.infradead.org>
 <4a8e2901-12b3-b700-383c-3193adc0ed60@huawei.com>
 <Z1bxqKIHreKySaGx@casper.infradead.org>
 <30caaca6-df23-c1cc-1980-88b83600807f@huawei.com>
 <Z1iBV9lLKKYwgL7q@casper.infradead.org>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <Z1iBV9lLKKYwgL7q@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHIoYT91hnOzoHEQ--.51391S3
X-Coremail-Antispam: 1UD129KBjvJXoW7AFyrtrW8Gr1DCr1UCr1UAwb_yoW8Ary5pF
	Z8Za1kKFs8Xr4kC39F9r15Xr1Dt345tF15u34rJ34SgFyqvFya9r4fK3Z8CFn7uw4xAw10
	gay7WFy2gry3tFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUF1
	v3UUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 2024/12/11 1:58, Matthew Wilcox wrote:
> On Tue, Dec 10, 2024 at 03:13:21PM +0800, Jinjiang Tu wrote:
>> 在 2024/12/9 21:33, Matthew Wilcox 写道:
>>> On Mon, Dec 09, 2024 at 02:43:08PM +0800, Jinjiang Tu wrote:
>>>> 在 2024/12/6 21:58, Matthew Wilcox 写道:
>>>>> On Thu, Dec 05, 2024 at 10:30:38PM +0800, Jinjiang Tu wrote:
>>>>>> During our tests in containers, there is a read-only file (i.e., shared
>>>>> Show your test.
>>>> I mmap an overlayfs file with PROT_READ, and call madvise(MADV_COLLAPSE), the code
>>>> is as follows:
>>>>
>>>> 	fd = open(path, O_RDONLY);
>>>> 	addr = mmap(NULL, size, PROT_READ, MAP_PRIVATE, fd, 0);
>>>> 	ret = madvise(addr, size, MADV_COLLAPSE);
>>>>
>>>> The addr isn't THP-aligned and ret is -1, errno is EINVAL.
>>> Then your test is buggy.
>>>
>>>           * Check alignment for file vma and size for both file and anon vma by
>>>           * filtering out the unsuitable orders.
>>>
>>> You didn't align your mmap, so it's expected to fail.
>>
>> When mmap an ext4 file, since ext4_file_operations defines ".get_unmapped_area = thp_get_unmapped_area", it calls thp_get_unmapped_area() in __get_unmapped_area to
>> mmap at a THP-aligned address.
>>
>> For overlayfs file, it's underlying filesystem may be ext4, which supports large folio. For this situation, should we mmap at a THP-aligned address too, to map
>> THP?
> 
> Actually, ext4 doesn't support large folios.
> 

I have sent out two series to enable ext4 support for large folios.
Feel free to give it a try.

https://lore.kernel.org/linux-ext4/20241022111059.2566137-1-yi.zhang@huaweicloud.com/
https://lore.kernel.org/linux-ext4/20241125114419.903270-1-yi.zhang@huaweicloud.com/

Thanks,
Yi.

