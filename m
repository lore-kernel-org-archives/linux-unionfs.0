Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED071BC41
	for <linux-unionfs@vger.kernel.org>; Thu, 29 Aug 2024 01:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724894733; cv=none; b=t5FU0tm83VQkbSCpQXUGYHsz7XNuwEVC7HJVmlCqOzRHeXceAyrreDw9nDJoOUuKgLvV/tX83AV7PFT/6zZigvZZg1NakdpOn59vkeX991lc1i7YEx8rA3JGre2+buRXHozTKR0Es7frXoOLWo6idj+gO0Tx55h6tEbO/eEdSeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724894733; c=relaxed/simple;
	bh=a7hLct/2iCGoJAsgdnHWfodKPd6cSmjWNiTYpTsRSzo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=BYsi85e0ABu4FUwUEdWzLLbfRapLldWVKaOzXZItO+IARZUXnh7RX7pjLRk3cqJiEV/KjLLY3OYmMgtOAByhSSxggUidh/jyIEsffiH0OYjFyQuHoIWYZqqTnOn8PpNt2hSo4H8ZsWiI9cICbe3hPlckJlVFNK4VF4D0rJFnuZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4WvNrC4ymCz1S9Bl
	for <linux-unionfs@vger.kernel.org>; Thu, 29 Aug 2024 09:25:15 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 636DA140257
	for <linux-unionfs@vger.kernel.org>; Thu, 29 Aug 2024 09:25:28 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 29 Aug 2024 09:25:28 +0800
Message-ID: <9bdc3c6b-095a-4cae-bb21-69d1c7706c0b@huawei.com>
Date: Thu, 29 Aug 2024 09:25:27 +0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] ovl: obtain fs magic from superblock
Content-Language: en-US
To: Amir Goldstein <amir73il@gmail.com>
CC: <miklos@szeredi.hu>, <linux-unionfs@vger.kernel.org>
References: <20240828120514.3695742-1-lihongbo22@huawei.com>
 <CAOQ4uxiBsGpEb3FUmp1Bn_9ch1Xa1aAqfpJa0qwVnN=23Mcfag@mail.gmail.com>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <CAOQ4uxiBsGpEb3FUmp1Bn_9ch1Xa1aAqfpJa0qwVnN=23Mcfag@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/8/28 23:17, Amir Goldstein wrote:
> On Wed, Aug 28, 2024 at 1:57 PM Hongbo Li <lihongbo22@huawei.com> wrote:
>>
>> The sb->s_magic holds the file system magic, we can use
>> this to avoid use file system magic macro directly.
> 
> That we can do something, does not mean that we need to do it.
> I don't see any benefit in this patch.
> Please explain.
Just avoid using the macro directly.

This kind of macro definition is like a magic number; once it changes, 
it will affect a large amount of code.

Thanks,
Hongbo

> 
> Thanks,
> Amir.
> 
>>
>> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
>> ---
>>   fs/overlayfs/super.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>> index 06a231970cb5..c809e845765f 100644
>> --- a/fs/overlayfs/super.c
>> +++ b/fs/overlayfs/super.c
>> @@ -256,7 +256,7 @@ static int ovl_statfs(struct dentry *dentry, struct kstatfs *buf)
>>          err = vfs_statfs(&path, buf);
>>          if (!err) {
>>                  buf->f_namelen = ofs->namelen;
>> -               buf->f_type = OVERLAYFS_SUPER_MAGIC;
>> +               buf->f_type = sb->s_magic;
>>                  if (ovl_has_fsid(ofs))
>>                          buf->f_fsid = uuid_to_fsid(sb->s_uuid.b);
>>          }
>> --
>> 2.34.1
>>
