Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3835513DBB7
	for <linux-unionfs@vger.kernel.org>; Mon, 29 Jul 2024 09:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722244967; cv=none; b=Fnm7TaDZY9canUb90MfooA3xQ1bfD588n00e6ur3MoidQOJpH3b10Wi3YklfG/79POB3IYfswUXvLDFV2YITyT6X3zhWL5wxZ2nhektKSzm7M1p/Q351nb9IGCzVL+maJh4RMbJI3z3zfk+6ChpcBC1HOFLJTarsApgwquzLIbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722244967; c=relaxed/simple;
	bh=Y9BbDaXldNlLgOlmUpDYUDIii9dGvPaX9HZL6LpJ7mg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oiv1U5qiBlGipZod2n9k71e9vQbOM3g71xVJwhHx5O8URt6qs1aKgZbs5xMsxHfBNJcqUhFN1rKxXkfsVgco5IhztXFHlsqCefJRTisV9a2TVwCCBsnYve3J/UylaFzBINBKwxtATa5PIj866Tx1xcby/jU0xSoeHHLdI/owkJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com; spf=pass smtp.mailfrom=shopee.com; dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b=ZpxhdfW9; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shopee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b="ZpxhdfW9"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-71871d5e087so2299249a12.1
        for <linux-unionfs@vger.kernel.org>; Mon, 29 Jul 2024 02:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1722244965; x=1722849765; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1i8EAifb5Q+Cho1w1hS5y73GUCf1y1+VSu7zJITVC30=;
        b=ZpxhdfW9X57wHjjtD6bH1sNvqIvUwO7Yya72IYVOeWegLBTUAzRfEr7Wyx20YxbfXR
         ERWWXTnB9a58PKvH+gPSdGsrQEgjs65t/o8+SXvFb7s+Htj735kJzXDiWqQbzQ/tjKZU
         dtdwkDHBxkggIa70o0EJyAU5amaQ03urq9HeGI8DsjTADK7qWT3sPSQEnz61SyQkc50h
         tKf0kq3UL7/bkoS799DptpZKcZs7K4vBwtcQv9j/iLOZPi2gX0UN1OGRVOz30Bq9NVO+
         dOIcnyUQIr1Ex8XXRrC9/cMqp1/luIN834pxM8Ba/5bFogxg/ASUu34sJyXE0gnnDEHk
         y83w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722244965; x=1722849765;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1i8EAifb5Q+Cho1w1hS5y73GUCf1y1+VSu7zJITVC30=;
        b=NbvNo7fKAJSGUKE4bFX4OwuzSN8A6kCVFgLCeV6RiYITWYsmXLJYVIubYBtDM/zq92
         kPsT0GTeakz50E6EAk0RycbTcL5ExAPezEmwmxmgryeuvmy3f8Kzu36QefAFPkEGd4OS
         Tmyaxr+eilmIkfxAheRP8EhNCc8HBx0H8BMLcZj6YgFm0rjomx8s3whLRFvQ0WBz2Ng0
         4T2z4LPyL8PP1J47vNYAwsPRqw1f2hS0KGBrYkCMTGJTzaYKuoIFm+qkEGk1dRUKQQdG
         4OnUFKhFeZsSBS3m5plOPWdAIOLyukf62/hAVuTqFked+M7HRnJKl2VUTfcHC8Jb/IpL
         zTMw==
X-Forwarded-Encrypted: i=1; AJvYcCVnaDpw3Dsi4e2rfAzMbzZY/CatwPY0On1Xdu5vYt3L13enjmR5+9ptV6mq/sB7CgvMlDK/Woud9xg3L1ACvYZhYZALbVrParFTeW5s2g==
X-Gm-Message-State: AOJu0Yw0KEoycGZDnphJI/J1/SUYEwKN+9IPV/qGfetsNwU71L2UZ942
	BM6PQqyWMu8vmQkBL6PswauIJJGh28Vu68L+FeEIl57CWqWJYX6iRN5rftoR2mk=
X-Google-Smtp-Source: AGHT+IGhEUZLiACZbdBW6nXsiQfCe+UvbYtq+wii9DR50uCySyNKfbex9nS2IhnqxPoziHJ1yN9D1Q==
X-Received: by 2002:a05:6a20:9146:b0:1c0:eabc:86a8 with SMTP id adf61e73a8af0-1c4a1183fddmr10157272637.5.1722244965493;
        Mon, 29 Jul 2024 02:22:45 -0700 (PDT)
Received: from [10.54.24.59] ([143.92.118.3])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cf28ae2d51sm8051429a91.0.2024.07.29.02.22.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jul 2024 02:22:45 -0700 (PDT)
Message-ID: <fc34fb9b-8afd-4f83-9e5a-e648b3358e90@shopee.com>
Date: Mon, 29 Jul 2024 17:22:41 +0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ovl: don't set the superblock's errseq_t manually
To: Amir Goldstein <amir73il@gmail.com>
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20240729034324.366148-1-haifeng.xu@shopee.com>
 <CAOQ4uxi4B8JHYHF=yn6OrRZCdkoPUj3-+PuZTZy6iJR7RNWcbA@mail.gmail.com>
From: Haifeng Xu <haifeng.xu@shopee.com>
In-Reply-To: <CAOQ4uxi4B8JHYHF=yn6OrRZCdkoPUj3-+PuZTZy6iJR7RNWcbA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2024/7/29 14:43, Amir Goldstein wrote:
> On Mon, Jul 29, 2024 at 6:43 AM Haifeng Xu <haifeng.xu@shopee.com> wrote:
>>
>> Since commit 5679897eb104 ("vfs: make sync_filesystem return errors from
>> ->sync_fs"), the return value from sync_fs callback can be seen in
>> sync_filesystem(). Thus the errseq_set opreation can be removed here.
>>
>> Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
> 
> I would add either Fixes: or Depends-on: to prevent accidental
> backporting without the dependency.

OK, I'll add this in next version. Thanks!

> 
> Otherwise you may add:
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> 
> Thanks,
> Amir.
> 
>> ---
>>  fs/overlayfs/super.c | 10 ++--------
>>  1 file changed, 2 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>> index 06a231970cb5..fe511192f83c 100644
>> --- a/fs/overlayfs/super.c
>> +++ b/fs/overlayfs/super.c
>> @@ -202,15 +202,9 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
>>         int ret;
>>
>>         ret = ovl_sync_status(ofs);
>> -       /*
>> -        * We have to always set the err, because the return value isn't
>> -        * checked in syncfs, and instead indirectly return an error via
>> -        * the sb's writeback errseq, which VFS inspects after this call.
>> -        */
>> -       if (ret < 0) {
>> -               errseq_set(&sb->s_wb_err, -EIO);
>> +
>> +       if (ret < 0)
>>                 return -EIO;
>> -       }
>>
>>         if (!ret)
>>                 return ret;
>> --
>> 2.25.1
>>
