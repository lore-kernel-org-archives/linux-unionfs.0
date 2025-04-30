Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE52218584
	for <linux-unionfs@vger.kernel.org>; Wed, 30 Apr 2025 09:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746004102; cv=none; b=kpTR0i9y5o92Vg5Uanwqw+AYTwB+LMhFrrunXA5YhHS1EGg1RYQYGc5C+XGAjXrFrf0PScs7OdUr9FRUflxPcfoAWoel8g5o242AMpHMU+Np0EfB6giSn8N9075j7fTlSdJEKty7w+WpGR0rlOydEJDhKcMozwXbACOFD/barcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746004102; c=relaxed/simple;
	bh=WQ06cfInUnLKA97xKzt5aHyl3AJCxltnuUTd24moQso=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o1CWC5jfpSgdwi8T9suOO75I/8zoD6EftPpStn/gyecckGXVbhk8uYsRpi0hsSJW6HZ4ojfhpDwjBJPxC1K7GIeU3RRLFV7jGCb912QvBSCIpO1sjMz9k6Zr6cXrrqiX8AOfO7txn5NAaGDFUyCvjqPQK6OO7Ik/QlQ73ytHTDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=N/j9DK9t; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="N/j9DK9t"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-476805acddaso88148721cf.1
        for <linux-unionfs@vger.kernel.org>; Wed, 30 Apr 2025 02:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1746004098; x=1746608898; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BhMpF9ZPTtusLyxadlrysDYthg/t1DJyaG/WQBBKCKw=;
        b=N/j9DK9tPFPLqP2NlfnUrhIvVVKASGxMuyOpkWGPXogR0zrPQVK3sc4DmSjPFte/x5
         owsOhnRhXDJOk8LJogAxkk2xrKkUIBh8prEpNDvF0+Xmf8GEB4+U/413k65waao1P3Du
         8sP9t0VgXW5jTFaU+YCl4YzYAj4QD/o17RiLw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746004098; x=1746608898;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BhMpF9ZPTtusLyxadlrysDYthg/t1DJyaG/WQBBKCKw=;
        b=Do+PDFUUMYO1giM9+YnCzIn6sfnRBUF3vhuQpAcDgTEzyUpxv2oc5k9NwU3OqQ3mfC
         +nhdqPOzNRV/xlo36+iIJ/NOQc89Vo8eGViZWBSwflD901Uil8K6YnA2yzgjfVFaAhM0
         cU8JE2uPiSfltvAyeD6AroLqow2ElKhGGL3KIqAAedlbnB48gYbQsfbFJTQr/4lXkosG
         AlbCXIPSX6Stn3fWsDrkfVXqwJUjSJ2vPltKgUU2j5Hm7cYOPIStm5XX29Lx7PK7r4YP
         tVWbKEDKaBq/8N3v0Ul6BcydX4GZZ3oENyrjochGJYwZuMZ546VyIVJRO3eKvQQpPzYi
         T7xw==
X-Forwarded-Encrypted: i=1; AJvYcCUYd5EsVl8gChPJHh4eafaPEkTznN5I6H93UrnOhnY94udW83ezhYN3x8xpsiGerG4v6VQBtBgjWMOZ2Mwo@vger.kernel.org
X-Gm-Message-State: AOJu0YxIkkFhzOzQEWubZ0WKVUAg6wUsG89kan0KhppAfgzFpqVKvV3b
	4j5LMGwazzp60br9t8yIjK3PuCYoDmZe7Ays8PGvsHs9ZUd4oIht5n1j7rlkExS+nG6IvxZHaG9
	O+UTo0CIIv+j5rt+knIxC9h1WOYEGr5WzDf75cnObqAzTKZoV
X-Gm-Gg: ASbGncsXVraq0O9xjKJXtZaIo8gnUQi0iDTAQSCenHY5XB84dyTLPf9SDfGEel4zjIm
	MMhu/1QwJACpc9EaU4+OnJXFnZmIsJP+7Vlb3p4TBojJNOCoRp2BkIpV3J25/PolZ3iB8j53OSH
	evhuhLQum4YeJ+hf0NGVVZcjxzgsAWXZR1kECVC/ypXdtnZoLbZqbYDio=
X-Google-Smtp-Source: AGHT+IGVG98iDSdK5lfsXQAEPtB0RBdUTnCRr6rYE2tT58B+Up30VLXz0bmholjrwMFdvFRX0rFvuoOuy5LcMubDIP0=
X-Received: by 2002:a05:622a:544d:b0:476:aa36:d67c with SMTP id
 d75a77b69052e-489c57f93f5mr39719451cf.49.1746004098321; Wed, 30 Apr 2025
 02:08:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250429183850.211682-1-andrealmeid@igalia.com>
In-Reply-To: <20250429183850.211682-1-andrealmeid@igalia.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 30 Apr 2025 11:08:06 +0200
X-Gm-Features: ATxdqUEpofBZK62vFi7AqnDOQPvWYkOAMkHP_DpJNRC3xvO-qNFpo2CmpBv2h4k
Message-ID: <CAJfpegv=CFjkAXLM26vFc0prGJ18aVeO3j_0LQSh290DQZn_+g@mail.gmail.com>
Subject: Re: [PATCH] ovl: Fix nested backing file paths
To: =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-dev@igalia.com, 
	John Schoenick <johns@valvesoftware.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 29 Apr 2025 at 20:39, Andr=C3=A9 Almeida <andrealmeid@igalia.com> w=
rote:
>
> When the lowerdir of an overlayfs is a merged directory of another
> overlayfs, ovl_open_realfile() will fail to open the real file and point
> to a lower dentry copy, without the proper parent path. After this,
> d_path() will then display the path incorrectly as if the file is placed
> in the root directory.
>
> This bug can be triggered with the following setup:
>
>  mkdir -p ovl-A/lower ovl-A/upper ovl-A/merge ovl-A/work
>  mkdir -p ovl-B/upper ovl-B/merge ovl-B/work
>
>  cp /bin/cat ovl-A/lower/
>
>  mount -t overlay overlay -o \
>  lowerdir=3Dovl-A/lower,upperdir=3Dovl-A/upper,workdir=3Dovl-A/work \
>  ovl-A/merge
>
>  mount -t overlay overlay -o \
>  lowerdir=3Dovl-A/merge,upperdir=3Dovl-B/upper,workdir=3Dovl-B/work \
>  ovl-B/merge
>
>  ovl-A/merge/cat /proc/self/maps | grep --color cat
>  ovl-B/merge/cat /proc/self/maps | grep --color cat
>
> The first cat will correctly show `/ovl-A/merge/cat`, while the second
> one shows just `/cat`.
>
> To fix that, uses file_user_path() inside of backing_file_open() to get
> the correct file path for the dentry.
>
> Co-developed-by: John Schoenick <johns@valvesoftware.com>
> Signed-off-by: John Schoenick <johns@valvesoftware.com>
> Signed-off-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>

Perfect, thanks!

Added these:

    Fixes: def3ae83da02 ("fs: store real path instead of fake path in
backing file f_path")
    Cc: <stable@vger.kernel.org> # v6.7

and pushed to ovl-next.

Thanks,
Miklos
