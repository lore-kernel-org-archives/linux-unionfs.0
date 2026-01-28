Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E090229E11A
	for <linux-unionfs@vger.kernel.org>; Wed, 28 Jan 2026 10:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769596626; cv=pass; b=IVP4Jo8AyLr/L3fj4TLSFohRscHmu7+Pp1QyNhcckDoQ+9u2FtOjcxHSjUg8kqduIfbSuoi2BYgHz8iyDrvQxN5AqxNbFB7bYmdSNAzgpk22jMyrWxcMk29SM6QgJ5KGYvTQm7KS6oC6eMVK3pJ2yAHE2z9Fj1EL7+8KiX+1kcE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769596626; c=relaxed/simple;
	bh=6Gss9V4UDi9tR1GjrXUZ6PfDXxHmSuyTTSGjQIHoay0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=etD/jEI6+q6yTnziItJTjZz/p/eNB11WU74fzjUQtDZYIuhGZo0K9pAC16+O7hQNWas2pWlb2GMmTly237Z6qIhrAMixJtUkBNCUuO+OKCfgzmVTmUR72To8MBTt2hmyKLwu0wLH4LKuU0GRiCf+dg57aqeYFh2Efd5IZR31Gkg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=DN3RWDBt; arc=pass smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="DN3RWDBt"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-88ffcb14e11so107480366d6.0
        for <linux-unionfs@vger.kernel.org>; Wed, 28 Jan 2026 02:37:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769596623; cv=none;
        d=google.com; s=arc-20240605;
        b=I1SfLPGf4eHeb77U0MEAVrmY+3D1nK1ULGoojeBWA/PrG8Y2g8kXSxdiRT4UYIBWn3
         08yXRhjL++mgEAOmrhdSylckouxWa1AxrjslbaBku4MrCQUvdD4UQuMHNIr6BeNhg18e
         0hcXsQIaJtTouvehMQU0NpEjtd0GjEofnIrnLzk258+C11dgTEm9CNL3BKHHgp8XHAUA
         cnDTKiVOQbBuMeWahIHyjAM1mg1gsu8SgCXnLmwfbBPo4M3nqhAHGLbCsNvvDzU5CgEQ
         j9xqNTgIQ21onbj2owgDTIfuUlv5ST2a90/3hqV8vwdD16OwkIZKy0yKwVRlpLkdrC3n
         aI9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=6Gss9V4UDi9tR1GjrXUZ6PfDXxHmSuyTTSGjQIHoay0=;
        fh=pfi4rt1iErB3tU3FZdVkNrmbDeytw4cnqRt8rQxovjA=;
        b=kNtP7vr0/S0BhzWACdVzRaPmWjcqw5NUFVm/KGj2TBA1vdS8GH7+80ewCfTnyAfUnt
         dh9A0y7udZzLfQFlWNSl9HErr18HkZbToHcLkFVZQoOS/7TwskzdenMZF3uqZyYQ0xf0
         YThHi4ApfDqtnr4h0euZOJE2QzKeeAttyeQ8RQ6kSP7bt8tDtlkWuWKNFY6Q/9SD7coh
         tTzjpFwf5kvxKUQpWqzbUW7lT1Ig7kgv+kb0njKqZOvDqsv4b5hXej7ypxeC31pMT3iE
         pZfJ8h7CWfs2thalOIG9PT2XmTDOEoRd8Q3wpc9b2eOqboky1qoMBO6likcBkZQuU6FS
         izVQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1769596623; x=1770201423; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6Gss9V4UDi9tR1GjrXUZ6PfDXxHmSuyTTSGjQIHoay0=;
        b=DN3RWDBtVFOnC7VDaje3UgbzX6cTp7E4xay+EicBTxE74StfQuhTPcUku/VFbK4+gd
         ZarSICFB7h4l/HBSTptoRT6nkAsoyXFw0CUxER5ym9VvBGBx54GTLeSp7Sda7fh2pw5w
         JfSZuIvjypy8nrrfpk4xILgg0IQBmYTaV79m4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769596623; x=1770201423;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Gss9V4UDi9tR1GjrXUZ6PfDXxHmSuyTTSGjQIHoay0=;
        b=Z+BAzr6u/dgWzuYtLib3qyb201i0SDYHYbbz8FryqaTTAjDculI51kBsGh11xYcHyL
         FalmKRK+n2QHofSdASpWfbR1bKk3rMGKrS4OOpgjxOD08sOXdPy3hGNUNq3CBqG1b3qw
         29p7K3MQj8KhoQKJGiug++shEcv82n8eE3F7pCQyWENAO/s/+d51E89ZdrfgPpiS6ixO
         DWghSguMOt1eDxVRmhProCxzWfXrUNF+vut73Gw5AHDYRahP5Psn3TmuwVjtj0OLXtkC
         USRLUT6Nd60FlzT+s+QrJbcLUMI+5B1C79AUzWGGj57tzhJokgfva7uxriyDg3GuGYW/
         n/lA==
X-Forwarded-Encrypted: i=1; AJvYcCU/lRg/wohWYOVa+xGIi5KLKe3aft6xrOjz1sjssABDquOi5dhKTEE5Tk9sIGoF39GE6TUkkz8cfHwvWXYr@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+8gAzrz0ceF/evoz+TmKwhFrkru3SOYuRJMTU7sglu72hS726
	aPT0guamG/oZn1v6wzJG/s3Unba4+cXKSDb2Q2/aTo6g+YcIxAbo5SGzi/bPwO/gQtyug89P/fJ
	5Nb0AwZe03Hb8pIWtKJ74QwT6INJOpmRYypdxcWjlQA==
X-Gm-Gg: AZuq6aLGiWPjPSQW4xmcEIPvzJNxjVslMv6jazDiDrJBJUtnb381EO3tkmejDUx2lsU
	UhAAM5UaUCEYhAv/2fGKeJS80BWvbDOsuLyYhCF6A4gsjIWT6b3CWbUXQOdBdFlNLQDSwv+pb7B
	Zs/Rg3eSaMPbbXegFVjVVlWPqJ/55+2XRT01Y3me/MgQ/6Wj5gTQmTSDERmUU+DnCcWp/jGT+WI
	jjPygohZRPMHQQuul2m3fRWPZuc0pPXOTdvEUSl7e3gCP1A+tEkCXJHnM9F4jpNQj69Z/c=
X-Received: by 2002:a05:6214:c2f:b0:882:5078:8da1 with SMTP id
 6a1803df08f44-894cc94b250mr70308236d6.64.1769596623378; Wed, 28 Jan 2026
 02:37:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJfpegt9yLioW1dEmGYOfib=TcuWVom=Z+a+bN+jS_8wFie90Q@mail.gmail.com>
 <20260128024212.1818250-1-wangqing7171@gmail.com> <CAOQ4uxhvnqg-_rB+1ch_nvZmP_s9a3RGxpaLP-9=UKTc9PWy7Q@mail.gmail.com>
In-Reply-To: <CAOQ4uxhvnqg-_rB+1ch_nvZmP_s9a3RGxpaLP-9=UKTc9PWy7Q@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 28 Jan 2026 11:36:52 +0100
X-Gm-Features: AZwV_QhN9ktitO_UPmPiocrAqoktTfnA4jIzrDQZBc5yohTiNbIzk1kf5PQaLzM
Message-ID: <CAJfpegtXE_DVBkkZSQ-URey-0odm7dEY05Qs9+Jr12-H5w=Zzw@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: Fix uninit-value in ovl_fill_real
To: Amir Goldstein <amir73il@gmail.com>
Cc: Qing Wang <wangqing7171@gmail.com>, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, 
	syzbot+d130f98b2c265fae5297@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 28 Jan 2026 at 11:20, Amir Goldstein <amir73il@gmail.com> wrote:

> In the meanwhile I'd rather apply v2 as is so it could be picked by stable.

ACK.

Thanks,
Miklos
