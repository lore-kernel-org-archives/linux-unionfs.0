Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706141E4A4
	for <linux-unionfs@vger.kernel.org>; Mon,  9 Dec 2024 06:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733726596; cv=none; b=XISP1Bj8eTggvjrgogK91/4J30G2D0OHyx7XhvpgX0ETqr2EknznIy52N8/wne6GjEuG358xw2QYpuREhvGB9GNE1i/XUznXRQf+2ydwQdtIBiDkrilsAibYKJjDEWv/m4SHY/8vEpoglC0LsVGEp3UFI7qHh9yKqh0HMdZ/QXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733726596; c=relaxed/simple;
	bh=b/tfw+6sxCIwbYuMzBzS9VkQGEi8Fru7z249BBYwhLc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=qNSqOXtUIHEeSG2zlnWt4X0bHrnNiQT23fcGgACX7XeCuaO1uHiGK3+U+LyATCRT6nk4VWUoSgQR8V+AZMYtxa9oo0lpSJImhgSyk3jm32oSyg4tXmRAgHqYzbVFhqsyMW09nrB+4zb0CWilyp8EjukY2LyzG5uuKMeoOIF1Dv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Y6C0Q50HWz11MBq;
	Mon,  9 Dec 2024 14:40:06 +0800 (CST)
Received: from dggpeml500011.china.huawei.com (unknown [7.185.36.84])
	by mail.maildlp.com (Postfix) with ESMTPS id C45681401E0;
	Mon,  9 Dec 2024 14:43:09 +0800 (CST)
Received: from [10.174.179.13] (10.174.179.13) by
 dggpeml500011.china.huawei.com (7.185.36.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Dec 2024 14:43:09 +0800
Message-ID: <4a8e2901-12b3-b700-383c-3193adc0ed60@huawei.com>
Date: Mon, 9 Dec 2024 14:43:08 +0800
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
	<wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>, <yi.zhang@huawei.com>,
	<tujinjiang@huawei.com>
References: <20241205143038.3260233-1-tujinjiang@huawei.com>
 <Z1MDIqKiyIdXTqji@casper.infradead.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <Z1MDIqKiyIdXTqji@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500011.china.huawei.com (7.185.36.84)


在 2024/12/6 21:58, Matthew Wilcox 写道:
> On Thu, Dec 05, 2024 at 10:30:38PM +0800, Jinjiang Tu wrote:
>> During our tests in containers, there is a read-only file (i.e., shared
> Show your test.

I mmap an overlayfs file with PROT_READ, and call madvise(MADV_COLLAPSE), the code
is as follows:

	fd = open(path, O_RDONLY);
	addr = mmap(NULL, size, PROT_READ, MAP_PRIVATE, fd, 0);
	ret = madvise(addr, size, MADV_COLLAPSE);

The addr isn't THP-aligned and ret is -1, errno is EINVAL.

>
