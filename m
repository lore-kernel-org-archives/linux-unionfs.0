Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8B010942;
	Mon, 28 Apr 2025 13:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745845289; cv=none; b=ERxrZd3MH1k/oCkyxu0/eC+bgY1dzVAHCvoDyI97e3NQWq9bPGPTRxVZMB+BjsyvZT0yI2HMla1uRQ/LY/S4bhUuMC9I6ZHP2h/YIB71YyfGF/rVL/AvYxvoeABnv6CJwWzzz2XpcFgxlQsY1biCnYqikpqbICR7ev+EjIQmhhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745845289; c=relaxed/simple;
	bh=jC0nARmRFRhXO9s3xUJyX7WxdPCEpxU8ehSIF6ss8X4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Tm4ezJzRR19l6fxIMWxeiHvgVLFLD0Kw17+blPO2Ywnv7LViAeTAhPw0NEJMUVLSMLTs31xlKoMGPLdD5IkqROWAGqug8HG79GL2XnVhNhsqqm9PQMbX+0SpPSVISLPy1cIj8Qf0J1Z9uKDx5vp4DzJv3vfywp8VzrYDfMOaidY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4ZmNqC1wsWz2TS39;
	Mon, 28 Apr 2025 21:00:55 +0800 (CST)
Received: from kwepemg500010.china.huawei.com (unknown [7.202.181.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 5F1BD1400CB;
	Mon, 28 Apr 2025 21:01:18 +0800 (CST)
Received: from [10.174.178.209] (10.174.178.209) by
 kwepemg500010.china.huawei.com (7.202.181.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 28 Apr 2025 21:01:17 +0800
Message-ID: <5e59d7ba-3b2a-40fb-b305-7b5a6316128f@huawei.com>
Date: Mon, 28 Apr 2025 21:01:16 +0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] overlayfs: fix potential NULL pointer dereferences in
 file handle code
To: Markus Elfring <Markus.Elfring@web.de>, <linux-unionfs@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>,
	Miklos Szeredi <miklos@szeredi.hu>, Yang Erkun <yangerkun@huawei.com>, Zhang
 Yi <yi.zhang@huawei.com>
References: <20250428111136.290004-1-wangzhaolong1@huawei.com>
 <0b8cbc01-0db9-48ae-ae13-7158a94a8908@web.de>
From: Wang Zhaolong <wangzhaolong1@huawei.com>
In-Reply-To: <0b8cbc01-0db9-48ae-ae13-7158a94a8908@web.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemg500010.china.huawei.com (7.202.181.71)

> …
>> +++ b/fs/overlayfs/namei.c
>> @@ -496,10 +496,13 @@ static int ovl_verify_fh(struct ovl_fs *ofs, struct dentry *dentry,
>>   			 enum ovl_xattr ox, const struct ovl_fh *fh)
>>   {
>>   	struct ovl_fh *ofh = ovl_get_fh(ofs, dentry, ox);
>>   	int err = 0;
>>   
>> +	if (!fh)
>> +		return -ENODATA;
>> +
>>   	if (!ofh)
>>   		return -ENODATA;
> …
> 
> How do you think about to reduce the scope for these local variables
> (according to adjustment possibilities for input parameter validation)?
> 
> Regards,
> Markus

Hi Markus,

Thanks for your review!

Inspired by your suggestions, I would like to modify the approach as follows:

1. Postpone ofh initialization until after fh validation
2. Return -EINVAL for NULL fh (as invalid parameter rather than missing data)

```
@@ -493,13 +493,17 @@ static int ovl_check_origin(struct ovl_fs *ofs, struct dentry *upperdentry,
   * Return 0 on match, -ESTALE on mismatch, < 0 on error.
   */
  static int ovl_verify_fh(struct ovl_fs *ofs, struct dentry *dentry,
  			 enum ovl_xattr ox, const struct ovl_fh *fh)
  {
-	struct ovl_fh *ofh = ovl_get_fh(ofs, dentry, ox);
+	struct ovl_fh *ofh;
  	int err = 0;
  
+	if (!fh)
+		return -EINVAL;
+
+	ofh = ovl_get_fh(ofs, dentry, ox);
  	if (!ofh)
  		return -ENODATA;
  
  	if (IS_ERR(ofh))
  		return PTR_ERR(ofh);
```

3. Drop the unnecessary "&& fh" check in ovl_verify_set_fh() since NULL fh would
    return -EINVAL, not -ENODATA

This changes prevents unnecessary memory allocation and makes error handling more
precise.

What do you think of this modification? Does this approach work for you?

Regards,
Wang Zhaolong
