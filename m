Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6204526561E
	for <linux-unionfs@vger.kernel.org>; Mon, 28 Jul 2025 12:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753706708; cv=none; b=JRAUyz6OdclkYGFvKuQb0FMCXackZT7WjB8sprZLF4bT+ujQXTrsHlFHkuPiSYScYTowqk7Lx04Hy4Ih5k/PZ5Q3N5OJGONBSD06JUzUIYReYD0YHjLefxoEEHqhCa4QHFiE7O8d1phewt7RVmajCawEAK4gCVWhTS06EepmnvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753706708; c=relaxed/simple;
	bh=3mffaSRrKUTzvQvfBPQRip+plp4Aeop4wd9/yuTAAf4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DVMwrOAUjjuTD2fFKhf9Bf5ZYsWovRJc/2m6GNmi1eucgAXqaUhHIrxS/qR+EUYSHoctg+fWzTaTO7bP8npWkIdUIY4g6wljtlRPMv4XaK/Dqf/oBHFmTnuP8ChKuyF4C2rVhj9zDkflIL+DXZ8R8Xn1D2ahPhLMhhtY6Lu1VzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com; spf=pass smtp.mailfrom=mandelbit.com; dkim=pass (2048-bit key) header.d=mandelbit.com header.i=@mandelbit.com header.b=JBzDX6XF; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mandelbit.com header.i=@mandelbit.com header.b="JBzDX6XF"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-451d41e1ad1so27019775e9.1
        for <linux-unionfs@vger.kernel.org>; Mon, 28 Jul 2025 05:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mandelbit.com; s=google; t=1753706704; x=1754311504; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=AXJU/8j+uYQVyVgG3LX90wQBRa26EXAPLD/1I5aQyoQ=;
        b=JBzDX6XFkUkOmBmadMCsn8MK8N61uG4VZfYpJsK2/InQOX27Yw2a9KCehdaRXsRsj0
         VWLDZ1lI0sScY5bcYlm3P+nOLALVzBo+nMl9Nl+N7fxQihNMO56p+mldHG2O4b1qGye0
         TFDbs/BSWVxJssIu7S6HovB5gHaU6Efeyz0PHNAIlgIxvn/0NaWK+gBzJgV1hTw1SlNK
         MmpO6B++Q0pjjdvUO9xwKX8UJwoxzvgvzxFppAWBudWyHpVlTE7s9oVxl6Rj2iy4hPLh
         NgVHfdZI5NP5MnffrVNTwb02ZQ1R9xmezUAghhro/XfbpKW3ZAfBjsk4hce4ijkxS9nQ
         NJIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753706704; x=1754311504;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AXJU/8j+uYQVyVgG3LX90wQBRa26EXAPLD/1I5aQyoQ=;
        b=N0ShUFk9fEDg+JRKDEFuwPxJpmpjytcATX5g8ddAnGYWS/0VXhILg+2BxZqs8oYj75
         ey0vjDYjjVNfQqZs8Ul2mze8UnnZG5nTQqvDjFMqZ4mLqa/QXmItCyXf3XKkc2S5S+yN
         8K/nssyB9LM/AumOPOUPIPlOUmmghHVZVoZhcQmElnK1dsevbvEDgjgRZ8PHf99zTBhw
         X8AmAB3CCRUChFP04Bk15dlZQFLsbXE77/9ZVIL+jXqnxh5uAeQSIqn8CfWlyRolcYsw
         Jhb3ukpPwZVuolw7+jVmp2nmAqxzlfQp+KvDzf7Dmr0fqUmMktLm62be1Hr+n40Z0IWf
         TtaA==
X-Forwarded-Encrypted: i=1; AJvYcCVWDIFH9sO/Z/GB9iwPs37XgZMV0cAZTuP62c8jNBQ45IEP0EalgPO0yTtsjnoINorhfeRIcefN7I2FxNDT@vger.kernel.org
X-Gm-Message-State: AOJu0YxGhZOZWHwSZibKlnbhGq346a41f43rvUqQw/W1j0Ax625ny8GN
	1rMrNlTMfHgw5HkXAtF+tj8dgn8APuS5i2uoFnr2XOMtcxMD5LqwxyJWXs1x7pwNcXM=
X-Gm-Gg: ASbGncsoH6yFiTGBf+vcUmLucltF/K2qwiKC6sT1A6V59NBmGsMUWtt+FJj2EbN9CL9
	tlWKKzvuJss60VOtyetHGlVB/VdcindHmyL6ztSfi6pA9nPPp4njTiWO0f/v9R3DzMPH2ZS2qno
	G6DHUqyqqa/kbAFzhMAKIzBTBzeV2oPrJqiztilzeDBky9xuj/EVzovybx+55vYVU5tN1a7oc9X
	UKVeZuTDPece2xNERA2/aNMTTeF3MqnaMQT03GUPa5chBxOhOp7LrLQ0JXY27vLv9Qr0wedIJMi
	2Psc2TGvs14tLpRyNNYdiew/13S7zLr3BmtNrjw/SpssK0vDNwGHlRAzqIotjm52oMfmVdN2oG0
	ST65iX8cfZcmZ9sV5Gh0bkShogLbA6460ML021isNJt1X2htRHTi2QQkjIk3FzYA=
X-Google-Smtp-Source: AGHT+IGZQJQeA3Dzy4idSOaGWXL75wVrswzHb6fD4Tgg9Jx+b8p5bbg4gzzDCiMLlXO5FUHXbd2AVQ==
X-Received: by 2002:a05:600c:1d1c:b0:456:13b6:4b18 with SMTP id 5b1f17b1804b1-45876663f5dmr88490805e9.31.1753706704134;
        Mon, 28 Jul 2025 05:45:04 -0700 (PDT)
Received: from ?IPV6:2001:67c:2fbc:1:cbb3:b83f:e6f8:7222? ([2001:67c:2fbc:1:cbb3:b83f:e6f8:7222])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705bcb96sm160332175e9.21.2025.07.28.05.45.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jul 2025 05:45:03 -0700 (PDT)
Message-ID: <a81e93e8-8292-4b8a-922d-15b770687f46@mandelbit.com>
Date: Mon, 28 Jul 2025 14:45:02 +0200
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ovl: properly print correct variable
To: Amir Goldstein <amir73il@gmail.com>, NeilBrown <neil@brown.name>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner
 <brauner@kernel.org>, linux-unionfs@vger.kernel.org
References: <20250721203821.7812-1-antonio@mandelbit.com>
 <542b0862-7f66-47ef-9ced-c66719842710@mandelbit.com>
 <CAOQ4uxiEBxFL1qD4p70UxjB67j9y8RX2r74LX5wDZ5aDDDZirw@mail.gmail.com>
Content-Language: en-US
From: Antonio Quartulli <antonio@mandelbit.com>
Autocrypt: addr=antonio@mandelbit.com; keydata=
 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
Organization: Mandelbit SRL
In-Reply-To: <CAOQ4uxiEBxFL1qD4p70UxjB67j9y8RX2r74LX5wDZ5aDDDZirw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

On 26/07/2025 20:27, Amir Goldstein wrote:
> On Fri, Jul 25, 2025 at 10:33 AM Antonio Quartulli
> <antonio@mandelbit.com> wrote:
>>
>> Hi,
>>
>> On 21/07/2025 22:38, Antonio Quartulli wrote:
>>> In case of ovl_lookup_temp() failure, we currently print `err`
>>> which is actually not initialized at all.
>>>
>>> Instead, properly print PTR_ERR(whiteout) which is where the
>>> actual error really is.
>>>
>>> Address-Coverity-ID: 1647983 ("Uninitialized variables  (UNINIT)")
>>> Fixes: 8afa0a7367138 ("ovl: narrow locking in ovl_whiteout()")
>>> Signed-off-by: Antonio Quartulli <antonio@mandelbit.com>
>>> ---
>>>    fs/overlayfs/dir.c | 5 +++--
>>>    1 file changed, 3 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
>>> index 30619777f0f6..70b8687dc45e 100644
>>> --- a/fs/overlayfs/dir.c
>>> +++ b/fs/overlayfs/dir.c
>>> @@ -117,8 +117,9 @@ static struct dentry *ovl_whiteout(struct ovl_fs *ofs)
>>>                if (!IS_ERR(whiteout))
>>>                        return whiteout;
>>>                if (PTR_ERR(whiteout) != -EMLINK) {
>>> -                     pr_warn("Failed to link whiteout - disabling whiteout inode sharing(nlink=%u, err=%i)\n",
>>> -                             ofs->whiteout->d_inode->i_nlink, err);
>>> +                     pr_warn("Failed to link whiteout - disabling whiteout inode sharing(nlink=%u, err=%lu)\n",
>>
>> while re-reading this patch, I realized that the format string for
>> PTR_ERR(..) was supposed to be %ld, not %lu...
>>
>> Sorry about that :(
> 
> No worries, but its not %ld either. the error is an int.

PTR_ERR() returns long - this is what the patch is printing.

> 
>>
>> Neil should I send yet another patch or maybe this can be sneaked into
>> another change you are about to send?
> 
> Please test this fix suggested by Neil and send a patch to Christian.
> 
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -116,10 +116,10 @@ static struct dentry *ovl_whiteout(struct ovl_fs *ofs)
>                  inode_unlock(wdir);
>                  if (!IS_ERR(whiteout))
>                          return whiteout;
> -               if (PTR_ERR(whiteout) != -EMLINK) {
> -                       pr_warn("Failed to link whiteout - disabling
> whiteout inode sharing(nlink=%u, err=%lu)\n",
> -                               ofs->whiteout->d_inode->i_nlink,
> -                               PTR_ERR(whiteout));
> +               err = PTR_ERR(whiteout);
> +               if (err != -EMLINK) {
> +                       pr_warn("Failed to link whiteout - disabling
> whiteout inode sharing(nlink=%u, err=%i)\n",
> +                               ofs->whiteout->d_inode->i_nlink, err);
>                          ofs->no_shared_whiteout = true;
>                  }
>          }

Actually I think Neil was suggesting to make `err` local to the two 
blocks where it is currently used.

This way the compiler would have caught its usage out of scope in the 
first place.

It should be as listed below (including the format string fix).
If you guys are fine with it, I'll send it as PATCH.

Thanks!

--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -80,7 +80,6 @@ struct dentry *ovl_lookup_temp(struct ovl_fs *ofs, 
struct dentry *workdir)

  static struct dentry *ovl_whiteout(struct ovl_fs *ofs)
  {
-       int err;
         struct dentry *whiteout;
         struct dentry *workdir = ofs->workdir;
         struct inode *wdir = workdir->d_inode;
@@ -91,7 +90,7 @@ static struct dentry *ovl_whiteout(struct ovl_fs *ofs)
                 inode_lock_nested(wdir, I_MUTEX_PARENT);
                 whiteout = ovl_lookup_temp(ofs, workdir);
                 if (!IS_ERR(whiteout)) {
-                       err = ovl_do_whiteout(ofs, wdir, whiteout);
+                       int err = ovl_do_whiteout(ofs, wdir, whiteout);
                         if (err) {
                                 dput(whiteout);
                                 whiteout = ERR_PTR(err);
@@ -107,7 +106,8 @@ static struct dentry *ovl_whiteout(struct ovl_fs *ofs)
                 inode_lock_nested(wdir, I_MUTEX_PARENT);
                 whiteout = ovl_lookup_temp(ofs, workdir);
                 if (!IS_ERR(whiteout)) {
-                       err = ovl_do_link(ofs, ofs->whiteout, wdir, 
whiteout);
+                       int err = ovl_do_link(ofs, ofs->whiteout, wdir,
+                                             whiteout);
                         if (err) {
                                 dput(whiteout);
                                 whiteout = ERR_PTR(err);
@@ -117,7 +117,7 @@ static struct dentry *ovl_whiteout(struct ovl_fs *ofs)
                 if (!IS_ERR(whiteout))
                         return whiteout;
                 if (PTR_ERR(whiteout) != -EMLINK) {
-                       pr_warn("Failed to link whiteout - disabling 
whiteout inode sharing(nlink=%u, err=%lu)\n",
+                       pr_warn("Failed to link whiteout - disabling 
whiteout inode sharing(nlink=%u, err=%ld)\n",
                                 ofs->whiteout->d_inode->i_nlink,
                                 PTR_ERR(whiteout));
                         ofs->no_shared_whiteout = true;



-- 
Antonio Quartulli

CEO and Co-Founder
Mandelbit Srl
https://www.mandelbit.com

