Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFDA1F95E
	for <linux-unionfs@vger.kernel.org>; Fri, 13 Dec 2024 07:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734076201; cv=none; b=GKdwF0OLFBnWSWZGQHLyIljlU9yRYIKUjSVHX+M7Lmvavl7Cwr7iq7DADfViJ3vwPST5glwE+oVG2IZO3gxHdQZ8XQTS6KgtkLw2dEr/hOc1Hwlq+0C/vbL9nzmYe82z3Fh4iV8CppHAhHan7+LQE/ctVtk1VPiVE3vdEi6cpyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734076201; c=relaxed/simple;
	bh=U5Zm29h7GVtGstqVkomkp2awahbBulzgWb3iigXB1eU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Z4Y+MBw7bUthcqNK8+rDX9alASwGGFtQiuQ9AeyzWIyyjvFH1C4fZg12NzmpVSihn+xadzpWcMFROZndkahn5uwFEa/Bd6SdiHRyaAtUBT2qK4MLwTVUeeEtwAn7OO/+Nu94+X8ByioOD7G+FEUMth3ya4pv7Jg7v85+Fo1Lbss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Y8hJH6R6bzhZTj;
	Fri, 13 Dec 2024 15:47:27 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 8D9361400E3;
	Fri, 13 Dec 2024 15:49:54 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 13 Dec 2024 15:49:53 +0800
Message-ID: <3207edaf-826b-4545-9c9d-906bfb4d312e@huawei.com>
Date: Fri, 13 Dec 2024 15:49:53 +0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] ovl: respect underlying filesystem's
 get_unmapped_area()
To: Matthew Wilcox <willy@infradead.org>, Amir Goldstein <amir73il@gmail.com>
CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Jinjiang Tu
	<tujinjiang@huawei.com>, <miklos@szeredi.hu>, <akpm@linux-foundation.org>,
	<vbabka@suse.cz>, <jannh@google.com>, <linux-mm@kvack.org>,
	<linux-unionfs@vger.kernel.org>, <sunnanyong@huawei.com>,
	<yi.zhang@huawei.com>
References: <20241205143038.3260233-1-tujinjiang@huawei.com>
 <69b72e3d-b101-4641-9ce5-51346c93a98d@lucifer.local>
 <041dcc1a-0630-27b9-661b-8c64a3775426@huawei.com>
 <a39ef271-dc1b-4f61-ba01-dde5b127bef2@lucifer.local>
 <f2668332-78ac-4dc1-abcc-440e38964ccc@huawei.com>
 <CAOQ4uxh5azF6As6TvV2eCKpnbct0-vNwJLTAwSiKc6QjK5TUBw@mail.gmail.com>
 <568698a0-c2f2-45d8-9d8b-e22e942fa422@huawei.com>
 <CAOQ4uxjBB7EUOnHB2n9BUGJ_TrHqvqJLksVyxcnpOUCR+7Tfyg@mail.gmail.com>
 <Z1u3S90PJL46-79U@casper.infradead.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <Z1u3S90PJL46-79U@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemf100008.china.huawei.com (7.185.36.138)



On 2024/12/13 12:25, Matthew Wilcox wrote:
> On Wed, Dec 11, 2024 at 10:43:46AM +0100, Amir Goldstein wrote:
>> I think this patch is fine as is.
> 
> This patch is complete crap.  The test-case is broken.  NAK to all of
> this.
> 
Hi Matthew, regardless of the test case, the original issue is the
ovl don't respect underlying fs' get_unmapped_area(), the lower fs may
have own rules for vma alignment(own get_unmapped_area callback),
thp_get_unmapped_area() is one case, what's your option/suggestion about
it, thanks.







