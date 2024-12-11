Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C594246343
	for <linux-unionfs@vger.kernel.org>; Wed, 11 Dec 2024 15:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733929322; cv=none; b=XaP1ydoicfRTB1ii4FszQLVECDFbyS7qU3S852uqUGzKJEj4VtGoEbmbZWf54JHcSqRMq6GENsE86e4i4nhDQsfhA1Pd0cZ3d+WdYH4PGlnmrisLDXkAUlzpEaGVamFM9S/4tWINSQESEYEQZjB0Vk4+ZBiVKHTGH2uGFQ/BgPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733929322; c=relaxed/simple;
	bh=Lx/46+QASQXW1m3ZI6nsfEs+VmFLot1znCmSbeYp9io=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=XtwOWYXD4Ux08mZNfHamQTxv6YcHpaYJdjNIkJ5n8PJ8QjldQrNgPs3rKiCRQtT6YZxKsOJhwOqk5wFsv6M7YKmzN76zVLngwPlJME6/JAYuAZ/fUv/+nef9VFXGiv0tf/dqbA2/acKjkycsDALIK8um649UPNzmv7aaGmOxTAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Y7dz54TT6zHwtG;
	Wed, 11 Dec 2024 22:58:57 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id C7E061401F4;
	Wed, 11 Dec 2024 23:01:50 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 11 Dec 2024 23:01:50 +0800
Message-ID: <88a1f4e4-8c3a-447c-a207-df754f1ab67d@huawei.com>
Date: Wed, 11 Dec 2024 23:01:49 +0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
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
 <568698a0-c2f2-45d8-9d8b-e22e942fa422@huawei.com>
 <CAOQ4uxjBB7EUOnHB2n9BUGJ_TrHqvqJLksVyxcnpOUCR+7Tfyg@mail.gmail.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <CAOQ4uxjBB7EUOnHB2n9BUGJ_TrHqvqJLksVyxcnpOUCR+7Tfyg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemf100008.china.huawei.com (7.185.36.138)



On 2024/12/11 17:43, Amir Goldstein wrote:
> On Tue, Dec 10, 2024 at 8:19 AM Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
>>
>>
>>
>> On 2024/12/6 20:58, Amir Goldstein wrote:
>>> On Fri, Dec 6, 2024 at 11:45 AM Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
>>>>
>> ...
>>>>
>>>> So maybe use mm_get_unmapped_area() instead of __get_unmapped_area(),
>>>> something like below,
>>>>
>>>> +static unsigned long ovl_get_unmapped_area(struct file *file,
>>>> +               unsigned long addr, unsigned long len, unsigned long pgoff,
>>>> +               unsigned long flags)
>>>> +{
>>>> +       struct file *realfile;
>>>> +       const struct cred *old_cred;
>>>> +
>>>> +       realfile = ovl_real_file(file);
>>>> +       if (IS_ERR(realfile))
>>>> +               return PTR_ERR(realfile);
>>>> +
>>>> +       if (realfile->f_op->get_unmapped_area) {
>>>> +               unsigned long ret;
>>>> +
>>>> +               old_cred = ovl_override_creds(file_inode(file)->i_sb);
>>>> +               ret = realfile->f_op->get_unmapped_area(realfile, addr, len,
>>>> +                                                       pgoff, flags);
>>>> +               ovl_revert_creds(old_cred);
>>>> +
>>>> +               if (ret)
>>>> +                       return ret;
>>>> +       }
>>>> +
>>>> +       return mm_get_unmapped_area(current->mm, file, addr, len, pgoff,
>>>> flags);
>>>> +}
>>>>
>>>> Correct me If I'm wrong.
>>>>
>>>
>>> You just need to be aware of the fact that between ovl_get_unmapped_area()
>>> and ovl_mmap(), ovl_real_file(file) could change from the lower file, to the
>>> upper file due to another operation that initiated copy-up.
>>
>> Not sure about this part(I have very little knowledge of ovl), do you
>> mean that we could not use ovl_real_file()?  The ovl_mmap() using
>> realfile = file->private_data, we may use similar way in
>> ovl_get_unmapped_area(). but I may have misunderstood.
>>
> 
> First of all, you may add to your patch:
> Acked-by: Amir Goldstein <amir73il@gmail.com>

Thanks,

> 
> I think this patch is fine as is.
> w.r.t. question about ovl_override_creds(), I think it is good practice to
> user mounter credentials when calling into real fs methods, regardless
> of the fact that in most cases known today the ->get_unmapped_area()
> methods do not check credentials.
> 
> My comment was referring to the fact that ovl_real_file(file), when called
> two subsequent times in a row (once from ovl_get_unmapped_area() and
> then again from ovl_mmap()) may not return the same realfile.
> 
> This is because during the lifetime of an overlayfs file/inode, its realinode/
> realfile can change once, in the event known as "copy-up", so you may
> start by calling ovl_get_unmapped_area() on a lower ext4 realfile and then end
> up actually mapping an upper tmpfs realfile, because someone has opened
> the overlayfs file for write in the meanwhile.

Got it, thanks for your detail explanation.

> 
> I guess in this corner case, the alignment may be wrong, or just too strict for
> the actual mapping, but it is not critical, so just FYI.

Yes, not critical, at least not too much worse.

Ovl is always lack of vma THP alignment or some other VMA allocation
requirements.

> There are worse issues with mmap of overlayfs file documented in:
> https://docs.kernel.org/filesystems/overlayfs.html#non-standard-behavior
> "If a file residing on a lower layer is opened for read-only and then
> memory mapped
>   with MAP_SHARED, then subsequent changes to the file are not reflected in the
>   memory mapping."

I think we could ignore above issue in this fixup and if there is a need 
to check vm_flags in ->get_unmapped_area(), we could deal with it later.

And Jinjiang, please send a v2 according to all the discussion.

Thanks.

> 
> Thanks,
> Amir.

