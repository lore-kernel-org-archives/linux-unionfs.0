Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0C17C0BE
	for <linux-unionfs@vger.kernel.org>; Sat, 23 Nov 2024 05:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732339400; cv=none; b=bqkit5RTQ3tUK5vpMA7G8sWwjxFM3eEaufjdouVBmu/uEdQtULLTOVyIcfve3jG7nYudZbfxJIayxVcoSCu2vXUfjtvZTyd6f3mp5Obq73rmIbSJ/QhHBkTld6kRuaoSIwhLs/c0QYgIzLEBG6MmdIAn0aWZB4lzI91U0hbI2P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732339400; c=relaxed/simple;
	bh=rU0rvkhWpzGBrA+g0K/jMXCk03/3N95dD4xq/uowYCw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gQf9m+AfVi3VxZGryezOHsuCxdL5DfVLDzHYeQaIm2efyOMNaZNy4ozcWkfmDNqyKYhf2khcZ7oInyMJOo7c6/jwEr6yeskgyFi19bF141tRfSX4eKwBLOUs4kos37e2Y4PRgxpwCNOjjWhu6GEDEn4IQA5en/85kWVHXP1evW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MD5SX6iK; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MD5SX6iK"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a9aa8895facso457787566b.2
        for <linux-unionfs@vger.kernel.org>; Fri, 22 Nov 2024 21:23:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1732339397; x=1732944197; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VSjGp3IroYTG1NE8bIcBd1OeNZO7AKZ38NmgfyznURE=;
        b=MD5SX6iKfEFaQEYdXcIOc9vFcj8niaKWWt9USx7qCwl9vHYiqRVpaWrYwI0l08jxfT
         mBuxbXZAL46Mo+RmcGVr+MjgB0Ecol3p6wMAPJ+DWtdgt2MRkVlcvPmLM9O3Wi+/rukL
         MzTIZFbKENFVRQymaVg0d/T4rr7alC7udUnNc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732339397; x=1732944197;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VSjGp3IroYTG1NE8bIcBd1OeNZO7AKZ38NmgfyznURE=;
        b=MFptdo/tPPRpM0ks0lsDFIPJ/B6ei7xeVynjpsIzBEci0QEfQ7zfZfSUdoRc00FjhV
         BcH4iutqhrBOVA+909i0umPZMACLUqrTDdszoiYqGjfPzUKDtD/g6frF+UTilzf63Lgv
         WhW5Q0C99gvLNInRL14uD+JbtNe5ZnsZTqHgHWjTZOGneQJGjoo8UAsNtwkW0nlXIM+F
         HCxNkS6OdSDMOPWfsxrw4k4TeF2YE6L65lNc2fussEgCqwsgdmKIaLUG7+eQ3rPgqKH9
         pQPIvZu1j6SChM9sNrEfInX2r2ZLDCVHPD3UJs59Z7fxhXW+iPKhLxQ09r9wE7pFgFN2
         sqUg==
X-Forwarded-Encrypted: i=1; AJvYcCUCrS7O1SEL71uWVm0luXg7MUGtU8ymlm8PlVo4YEMpRseA37oAgE61waWfnWmD/XsjuQUWtdHtgL6rVY76@vger.kernel.org
X-Gm-Message-State: AOJu0YzyDFC5FpqqptDzxYRuv7glIQV1Ib2a4xbsaUbPclo56BGZGZX8
	uuhSdKbu2LQLY55DA5H6i4ONfe1hXj9BDOHUHBFwOk6ULaKO9X4NNW+gcPYt9jvN2M+1n4WZoiy
	vI5R4aQ==
X-Gm-Gg: ASbGncvohGU1LAhpxASwpNdHj/FDxj1WFdUsQ4kjukFylGLfWB4Q3ytyxw269o9WA/A
	X/Bhdo9XN3zmY4DQnAX2E3FaZoWqKvb701YSJfog8SDJNIE7z2iiShkhy64qxvJeaiNlA+RbHNJ
	1guHdAl4U2H0TObrxwj2PUL94QevDw9rPjaXKskS8ByyWHzvoN15QGQemKO+XAMyFJIlxKhlbXG
	vUb5zKNy9XO1+AcHYg5tu9OfuXY73r4sJjgRWK2625MsgZG+PBYIg891racPHeSyfBRXhoW5uJQ
	Fu40EiGipWZhVg6YHOe8rzcV
X-Google-Smtp-Source: AGHT+IH3tAoKEKy8mBA0EsLSMygyYZIa0YzcsAyNVwq6mL1+BL8FEj8dCaNNv9pL5JXf7kukKeMIVA==
X-Received: by 2002:a17:906:292a:b0:aa5:1cbd:def8 with SMTP id a640c23a62f3a-aa51cbdeea1mr327561666b.17.1732339397026;
        Fri, 22 Nov 2024 21:23:17 -0800 (PST)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa516396f6asm151743766b.158.2024.11.22.21.23.15
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Nov 2024 21:23:15 -0800 (PST)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a9a0ec0a94fso403417266b.1
        for <linux-unionfs@vger.kernel.org>; Fri, 22 Nov 2024 21:23:15 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXcxIZ+vT03u0VgTks2S/YV2ahRABoP8rErh3+Pcds7hm9xPtqj59ep6Ng2fP58DN7OyGGihABEA6PKO3mA@vger.kernel.org
X-Received: by 2002:a17:907:77d6:b0:aa5:31bb:2d with SMTP id
 a640c23a62f3a-aa531bb011emr102010766b.20.1732339394655; Fri, 22 Nov 2024
 21:23:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241122095746.198762-1-amir73il@gmail.com> <CAHk-=wg_Hbtk1oeghodpDMc5Pq24x=aaihBHedfubyCXbntEMw@mail.gmail.com>
In-Reply-To: <CAHk-=wg_Hbtk1oeghodpDMc5Pq24x=aaihBHedfubyCXbntEMw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 22 Nov 2024 21:22:58 -0800
X-Gmail-Original-Message-ID: <CAHk-=whRp-s-GNZNdtCe8dOhpM0zihk4wUAXK2RsCf69fSW99Q@mail.gmail.com>
Message-ID: <CAHk-=whRp-s-GNZNdtCe8dOhpM0zihk4wUAXK2RsCf69fSW99Q@mail.gmail.com>
Subject: Re: [GIT PULL] overlayfs updates for 6.13
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 22 Nov 2024 at 21:21, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So I don't actively hate this, but I do wonder if this shouldn't have
> been done differently.

Just to clarify: because I understand *why* you wanted this, and
because I don't hate it with a passion, I have pulled your changes.

But I really think we could and should do better. Please?

               Linus
