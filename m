Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81383D69
	for <linux-unionfs@vger.kernel.org>; Mon,  8 Jul 2024 03:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720407931; cv=none; b=RmsCm31jfvSusWJaSA62RSgTAYZNHFEI88Z1ILnkStpPhmJRW8MZmvo2h1m6Pyjfy9sIKcqeOzGzdUqzwUEvR7YDUQ6Z2uQEd0Oj/teFnAKFLufDM62DWHkz6Dj1zudGnZ7bZ9AwGHPdcOtCQljD+ofNj6bD0zVrdTHhRGJGHHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720407931; c=relaxed/simple;
	bh=nw8J4Z51UH6xDa5HdqiQsk81EStWwo5AdliT7KdocD0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pw4Bn366DY7RS6BC2+GbNO0ZXLGVUI7KrxH7cr2oTkNhEWCnBXEdrWsNYWqaEfe9z0deweVxy1zCSIPCURJdRT8CDy+rnq71iXVsg6WRAJ0ygsGRQb8ti9jmRPmCutdxBmhOnKQQ0IDRmyfUMOv3dZrVAlX4IN24FSiMFK8tllI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mbaynton.com; spf=none smtp.mailfrom=mbaynton.com; dkim=pass (2048-bit key) header.d=mbaynton-com.20230601.gappssmtp.com header.i=@mbaynton-com.20230601.gappssmtp.com header.b=r/0CEO8N; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mbaynton.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mbaynton.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mbaynton-com.20230601.gappssmtp.com header.i=@mbaynton-com.20230601.gappssmtp.com header.b="r/0CEO8N"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7eba486df76so79411539f.0
        for <linux-unionfs@vger.kernel.org>; Sun, 07 Jul 2024 20:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mbaynton-com.20230601.gappssmtp.com; s=20230601; t=1720407929; x=1721012729; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X37PbaunERtwm/jJ9HFDekKhEk45BOr8oKCY4JM124I=;
        b=r/0CEO8N5mmvsYN9VE8rhO/EadbNFmqpqPOV3iiaimwAkT1isszm572QZxSx7u1tun
         BTZK6rgaYr25/ddM+T1Lw0mg09MOkLhq0K0i5Nm3brtvrA+j1d2tbnUi5nJooAkDhUGx
         MjQjFnFeiePfM7/KHkfpQ2BeYq7E7ChvVsF3j1OlLPyCS7HNxEn9KHbSmZqfyfsEd4V2
         y8USnjITVxxilPJY1YwWXrQbD2Uj3mJ5Ult83DfCWS62gyXnsHGjWAeohvMNXjiHrLGK
         DblL+tUMnwaZF8BFky0NSDWbEmRW3JJLEVhDlHkxXS4/6BTeoxMltDS9cmRALCvlMyEP
         /DWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720407929; x=1721012729;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X37PbaunERtwm/jJ9HFDekKhEk45BOr8oKCY4JM124I=;
        b=D0xCZJiem3C2RBeeG1YzB8yv76wYeRTVNfFid3Ji5YSYB7ya+GY6E/QrN6mHgqPzm9
         sKYE//yq/Vly5ImbH2M5/V8o1JZR0TMkK0VjNfulNrQCtH1Opl25e3qkynaGI270es3s
         B+hHxRU3EzSzQW/E3jZkgEJ9Z9744P/lUjKNlhYwhznilQ1ihGWbI+U/h7IsBHOuMF7W
         /pegcKP1M2Z1ckdyCIXyrlgYvYfOzXeq8pR2+tsK7yq8MRqCOE1XUO9ZURwavvIn+gva
         PI9t+33WJNm7nqrwgVsiIoZaWFZ1k73KaNLWEl42IWq3ni5qXKFWVizb3HT0h3CJXWda
         GeqA==
X-Gm-Message-State: AOJu0YwGXlgF3sqWOMpGjPfAqdaaSq2rkfJreQZlfXyUd7RXkzJ2kW8P
	/6YYlCwlfPI8mt7/rzumqcVCb/kj+sq9XRKqu+ctMjC9adXtIiIGhRipmLJH95rzFKB8MRMbWPP
	GR14=
X-Google-Smtp-Source: AGHT+IGTNpgs7+a6o96Zja+qXJ0D3ZS+a5G3E5jqgtA3grkOjsPjq4+/YE+mhHebpFOWsUdcbOg5pw==
X-Received: by 2002:a05:6602:6e8e:b0:7fa:244c:bfe9 with SMTP id ca18e2360f4ac-7fa244cc136mr224044439f.1.1720407928883;
        Sun, 07 Jul 2024 20:05:28 -0700 (PDT)
Received: from ?IPV6:2601:444:600:440:7abe:3dd6:a795:ac49? ([2601:444:600:440:7abe:3dd6:a795:ac49])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-7f9c925272fsm119173139f.11.2024.07.07.20.05.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jul 2024 20:05:28 -0700 (PDT)
Message-ID: <2e8c4e8b-3292-4ccf-bb63-12d7c0009ae9@mbaynton.com>
Date: Sun, 7 Jul 2024 22:05:26 -0500
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Data-only layer mount time validations
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
 Alexander Larsson <alexl@redhat.com>
References: <20240705042542.2003917-1-mike@mbaynton.com>
 <CAOQ4uxj2x1t4J51penjLJD5c0U7Xm=3ytJZoW37jY2AKxHDknw@mail.gmail.com>
Content-Language: en-US
From: Mike Baynton <mike@mbaynton.com>
In-Reply-To: <CAOQ4uxj2x1t4J51penjLJD5c0U7Xm=3ytJZoW37jY2AKxHDknw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/5/24 01:35, Amir Goldstein wrote>> ---
>>   fs/overlayfs/super.c | 13 +++++++++++++
>>   1 file changed, 13 insertions(+)
>>
>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>> index 06a231970cb5..4382f21c36a0 100644
>> --- a/fs/overlayfs/super.c
>> +++ b/fs/overlayfs/super.c
>> @@ -1394,6 +1394,19 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
>>          if (IS_ERR(oe))
>>                  goto out_err;
>>
>> +       if (ofs->numdatalayer) {
>> +               if (!ofs->config.metacopy) {
>> +                       pr_err("lower data-only dirs require metacopy support.\n");
>> +                       err = -EINVAL;
>> +                       goto out_err;
>> +               }
> 
> Is that not already handled by?
> 
> int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
>                           struct ovl_config *config)
> {
>          struct ovl_opt_set set = ctx->set;
> 
>          if (ctx->nr_data > 0 && !config->metacopy) {
>                  pr_err("lower data-only dirs require metacopy support.\n");
>                  return -EINVAL;
>          }
> 
> Probably because of:
> 
>                          ofs->config.metacopy = false;
>                          pr_warn("...falling back to metacopy=off.\n");

Yes I think that's right.

> 
> in xattr check, but it could also happen from:
> 
>          /* Resolve userxattr -> !redirect && !metacopy && !verity dependency */
>          if (config->userxattr) {
> ...
>                  /*
>                   * Silently disable default setting of redirect and metacopy.
>                   * This shall be the default in the future as well: these
>                   * options must be explicitly enabled if used together with
>                   * userxattr.
>                   */
>                  config->redirect_mode = OVL_REDIRECT_NOFOLLOW;
>                  config->metacopy = false;
>          }
> 
> So maybe also the lowerdatadirs vs metacopy conflict should be moved
> to the end of
> ovl_fs_params_verify()?

Or possibly just remove it from ovl_fs_params_verify() completely and
only check it once, after all adjustments to metacopy have occurred?

FWIW, I'm personally more interested in seeing the data-only layers from
a user namespace case fail at mount time than these various other
scenarios where metacopy can get switched off. I'd also be happy to 
confine a patch to detecting conflicts between no access to trusted.* 
xattrs and any of the features that needs them.

> 
>> +               if (!capable(CAP_SYS_ADMIN)) {
>> +                       pr_err("lower data-only dirs require CAP_SYS_ADMIN in the initial user namespace.\n");
>> +                       err = -EPERM;
>> +                       goto out_err;
>> +               }
> 
> This is too specific IMO.
> 
> If we really want to check CAP_SYS_ADMIN at mount time, we should error
> on any configuration that requires trusted xattrs and suggest that the user
> will use -o userxattr, and maybe disable the conflicting config if it was not
> explicitly specified in mount options.
> 
> Of course, userxattr conflicts with some other options including
> redirect_dir, metacopy and verity, but that just means that the errors
> will have to be smarter and the check for CAP_SYS_ADMIN should
> definitely be in ovl_fs_params_verify() if we add them.

This makes a lot of sense to me. Thanks for your review & suggestions.

!capable(CAP_SYS_ADMIN) is the proxy I chose for "no access to trusted.*
xattrs" but I think it's a solid one as that's how xattr_permission()
does it. I was thinking calling xattr_permission() directly on the
first lowerdir or something to test if we can access trusted.* would 
just complicate, but I could be wrong.

I'll take another stab at a patch in ovl_fs_params_verify() and focused
on no trusted.* access + metacopy/redirect/verity in coming days.

Thanks,
Mike
