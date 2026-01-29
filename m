Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84A2377543
	for <linux-unionfs@vger.kernel.org>; Thu, 29 Jan 2026 08:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769676257; cv=pass; b=GgtB//IzLAZvRdL7IQv4kC3ElPu8CFxnprgFVMApPbPZiChEyR4jAxscvdd9s7vc+RacwVFfRq36+WDppZxOXtLSZoDYgVEnPBxxzvym1LQIRNlB19l7f9WDJ8c/FInjPnPhtUi+l9ZOb+74e3Hm9J5KMj+w8cuhFcE+H7V1fqQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769676257; c=relaxed/simple;
	bh=aNBF2tfc1d7N1rBEkGHPce+HjG2Uc3PNS9wxeknnHFQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KseVAr5kfbxB6Vcqz84KPypP/RrCK0gRpQwF1SWHqJyJxbJSlotN4zEmuznr9oFM9KBuTid7rYWMjAVICJEH+YzjLAznR1ynbtWVrRL58anaDwQLywYMwECXbQ6DcDyoHWbxAaikgcEiGxcgz3HV31swBIanCqL2yD5b3yT+MnE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=bGXai3Ra; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="bGXai3Ra"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5032e951106so6596681cf.0
        for <linux-unionfs@vger.kernel.org>; Thu, 29 Jan 2026 00:44:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769676251; cv=none;
        d=google.com; s=arc-20240605;
        b=bBxgemeanvkalKHPNNv2IboUUDTvy5BHS7zISXznZINXpHdk45+871c7A8vBokiHOZ
         cJr+jJq29GqmXDNp/35QoZDun88/3EAsKKE5xjQJDDHVxn5r7OO/C2sAEmdrIsycnPoH
         3XtLUc9u0g+Uwz9ADHnqxUu1HP9RJLLzMTjZ9oSmvh+ncbRvl29/QDXTCvIH4+5bNXNq
         2AxQKe/xJ1q8ZFFaDqckTtByd87AzD0thsEkYuRazaCS9+SnQ5MiQ4yVCe1eSMId0XMI
         F2wBhnDALF/OYRe3qH/3TN/ZMaoOUG/Rzqgenr73hAhqBqYuBJWaPhxg2aRWdHy3DcNv
         obhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Nmq4jeEyP1daRxqgd0+ar4RlYr0t2eY5PfXIJffiuBA=;
        fh=pZEz3SVYeQVXkeTqV8mvLQOT4YbE34nbovM1pngRAik=;
        b=aUlQABLxaP+tbkcAIt2BnFcloIS7OQo5gUAD0PBrRvrq03ripshjK7fex+ym2fvpWE
         FNjp3yB1TjUL/aRy/HNc2rPgmu4gNZoXgQGn1pwyETjWcYa3mL0w3FQaVKmf0m52H103
         nMqygBz0vmOee85t0pnycqNtgJ8CjHXkrkJsJ4cKcGuL+dyDaKIn9o2N1BcuSTtFkqR6
         +Q3JzOKOPFWcTCzEF77TMQH/0Y1MwGu///CZpoFiUyqeNHpe627zVSInr2aMMkHgIR7M
         2gLPj7QXHjnjUrjZlehA+jOrSNOtYX0X2L1kkJ8I2hM68eT88JDtUgLuECGuoWGSdUnw
         HXoQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1769676251; x=1770281051; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Nmq4jeEyP1daRxqgd0+ar4RlYr0t2eY5PfXIJffiuBA=;
        b=bGXai3RaGJqADXtcnpgE5vlDWM3Qub8CaIFMI57kSnjEJ8SQg2fWHhqKMw8grHig5C
         kPM6FWakWtWRABwAcg4b64KmTcGhDOhIItd+U/POX7BNvj6rWqb9a16jjBrlOWfuXIDK
         uINhuhPf9XjsIG1EJjoG9NaIpqH9uQfrD52hE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769676251; x=1770281051;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nmq4jeEyP1daRxqgd0+ar4RlYr0t2eY5PfXIJffiuBA=;
        b=Ui3Q+pPQXjO6BafoNDSONw8BKq1Ylo9SGZLQYfKwmajZYg4OacJ14v0HLcjRNVOoB2
         Q0F2i4kFpjxq4qsdBr0eAn1czffVf9HUU7/mGFYhcrpGdV5nr0NBcVyaGcd/+OyYdTiw
         qj0LtOVMqh1525VL9tEQzBhH3QZByODwimwpUIbvSqmt3cltc1Jm3r/xQk6L5BBZX/5x
         LUDXIGvDxwxMHEgyKyCZBzefCt1MTzdtoE7v4lKtFoX+H36fRqviUcoexE5WZR7COpPO
         YbGJZ2VX2d6LUum4b1r06nWYYtqh+11MR1LUyH6XnkMdkxNnGaxUNI9FNheNzaQ6o60e
         LW0g==
X-Forwarded-Encrypted: i=1; AJvYcCU7b0GUB6IYDMDtqfDiQbndDHCohOSqn4MROMcARqFjU5hxRhRA0yC8BI+qiHNAqbS9E4YwzgALr88H50hM@vger.kernel.org
X-Gm-Message-State: AOJu0YxjHFeuhd86qm07AXfgAuyg7WPdXn7CludtouJHu3YysWMn8F/g
	cOMlutAwXBKAQ8tOygnq05uK5n9Cmh/X+zzwVD0e35j5ps9DDKDATxgBVASeucQV6d05gu6xsRf
	a1NCyJz2TYheTrOBkx7yHHfMwRVOo7u5H2Ua3dgxOkg==
X-Gm-Gg: AZuq6aIQF7B32HnJiuEvg8M+pyTlJloYignjLvWL4Y1IcoNxrD1hhvOf/ronh+30Zrw
	HPzZ60cKhcxBYiIqJ/ls69YzcNG5baGjGytIFVM+z/hw980NbsBN24t+sc3Hyj+l5EHyfwpDLE7
	s26F59kB0iYBFvcP8eH8vXQT70N1JRbe094STJLfgb4oOCJuHgUoYaFTM52N1WJRt2YBbBS7BkC
	VQRtz3YQ0ba7BRtWlAP20VBq22+hyYUZQz8qKWwF9dxz8kj8sg42ghXtP3h/eioNqlSLcrBmESf
	f38fRw==
X-Received: by 2002:ac8:5f93:0:b0:4e8:baad:9875 with SMTP id
 d75a77b69052e-5032f7703f0mr103157531cf.4.1769676251543; Thu, 29 Jan 2026
 00:44:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260128132406.23768-1-amir73il@gmail.com> <20260128132406.23768-2-amir73il@gmail.com>
In-Reply-To: <20260128132406.23768-2-amir73il@gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 29 Jan 2026 09:44:00 +0100
X-Gm-Features: AZwV_QhTORoCIcikGWuj-UN4jliOmcUObBb7dF7LwnNwDRty0uXM6TNS_9tay2Q
Message-ID: <CAJfpegu8owOkpyNkcKHbz-eQWLWhrSE06hY2b-kQqSPq7gbH_Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] ovl: Fix uninit-value in ovl_fill_real
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, Qing Wang <wangqing7171@gmail.com>, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	syzbot+d130f98b2c265fae5297@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 28 Jan 2026 at 14:24, Amir Goldstein <amir73il@gmail.com> wrote:
>
> From: Qing Wang <wangqing7171@gmail.com>
>
> Syzbot reported a KMSAN uninit-value issue in ovl_fill_real.
>
> This iusse's call chain is:
> __do_sys_getdents64()
>     -> iterate_dir()
>         ...
>             -> ext4_readdir()
>                 -> fscrypt_fname_alloc_buffer() // alloc
>                 -> fscrypt_fname_disk_to_usr // write without tail '\0'
>                 -> dir_emit()
>                     -> ovl_fill_real() // read by strcmp()
>
> The string is used to store the decrypted directory entry name for an
> encrypted inode. As shown in the call chain, fscrypt_fname_disk_to_usr()
> write it without null-terminate. However, ovl_fill_real() uses strcmp() to
> compare the name against "..", which assumes a null-terminated string and
> may trigger a KMSAN uninit-value warning when the buffer tail contains
> uninit data.
>
> Reported-by: syzbot+d130f98b2c265fae5297@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=d130f98b2c265fae5297
> Fixes: 4edb83bb1041 ("ovl: constant d_ino for non-merge dirs")

Cc: stable@vger.kernel.org
Acked-by: Miklos Szeredi <mszeredi@redhat.com>

Thanks,
Miklos
