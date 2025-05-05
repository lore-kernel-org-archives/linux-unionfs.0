Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C875D224AF8
	for <linux-unionfs@vger.kernel.org>; Mon,  5 May 2025 12:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746446774; cv=none; b=DvaWU5SQgY8Yqz9u3VBpWkwp0gVbEaasy72qKA4Z0s5MhLz82nvGCEYSwbUSmL+8ZJf5EZYIMdnnRtRfLLDuOxNFe1MUux3k4uRSf59sKcOqozuF6uvFUBwjqS+8C+LzyonjNXyHa5ZIdH5Nwh45in9RM17pHw3x76DPZ5jbjgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746446774; c=relaxed/simple;
	bh=ZaJvxtjr/UbWDuYMsc++2AbU/9RuxaJOqfgbALnPUfo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oJL/h33xn8u6KvktK7pre6eYPau3plPwoScYCZJpvIl1HIZBL0mU0tDii8R7EUzkSOZC/N0F1pJGsEoaAojAsdlBTOzsYZbwrMoSDaz4tbkt/Bb+lSnOJAmVGYjqjMU2dALbetxJ7LWM9b+V/DL4tNZ/kenAZfzcmbM3pnJ+Mbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=OkqqroQl; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="OkqqroQl"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-476b4c9faa2so65053991cf.3
        for <linux-unionfs@vger.kernel.org>; Mon, 05 May 2025 05:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1746446771; x=1747051571; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZaJvxtjr/UbWDuYMsc++2AbU/9RuxaJOqfgbALnPUfo=;
        b=OkqqroQl0x/jqrx7vKiSH+a4gYhrssvcXVeHU++Q9KmgH5YrnY9ocxud3BTo9JUZhX
         7/XIncJ08fZBJni0ImFstaWuEfFim2XwwmbegBkvSEgSaQA4AfaI2FYc6QzXQnF7FqN0
         TPulG4Ib11i8jhTrWJqSgEuro1Xo0/m+VWHQ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746446771; x=1747051571;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZaJvxtjr/UbWDuYMsc++2AbU/9RuxaJOqfgbALnPUfo=;
        b=nMIgrRXK4weBvRJTm9W7jz4BPyXBggUt4xO9s7mgi49tfOnR83wn+jjY1LglD+G4oi
         0Vq8haLrKOz8DKZ4mdHeAZ0Xoen1Eczx4FPRwv43/BX89b0qYw7Ft/V5zu5YKwV86wP8
         4Y1sg5huJpuNkncgM7+dwfPUi3ALeNX34ydyvI+VPeb5oyMnLpKqeOgTZ3gRrUzFa6Fd
         HTDfl+C/WsrxzhE6Iq/ny6pNfDA6SghdIJ7PEcwaGH/KOGH7C46QrYAhUZUszCvsRE1I
         mZWIqYer8xufTyM8xkTKo5zd0NWUfNcuFZPjYA1cXOAVhZnZ7XsfQW5CUiZVHJEUZCZs
         9x5g==
X-Forwarded-Encrypted: i=1; AJvYcCUgrjwPpIT9Xh3WVR8iFItSCv09c6ZqclG1LdVdTegWT2S8LbLeoK/PF5ut8zhT4LiFpNzuQDAqux4DeNEg@vger.kernel.org
X-Gm-Message-State: AOJu0YxEE6QU0bso9vfRkyUQOAJpXTidYkADPeUCrEPSRzfoTLb6X7Mr
	Dx5yGlPs0iQqtr6io99r1jGfI9rKzO16EwZ39y1JEOXnbuFql/NcLi2zZCdnEvpp2pIoJnW1M7D
	uANJ01+7mJgtQyyHEzywnZZz6ywb6JyczFxOSmQ==
X-Gm-Gg: ASbGncuND0H71QPvnIG+Kj4F+UdPcHaG+ae719A7tOLXBeDhXxdNkjIgtfPRdcFW/qI
	0dzy9ItXVSva8+4GHreUpCZw5YU1Si7O94I4wWrBFgWd9nWFvysDkXLwQldHVeixy9u6rqgJBYx
	U/ZbSgUTpEdO/yueOSkK8BmD4=
X-Google-Smtp-Source: AGHT+IH8SI5HcYSna3MRmrF+Jzo/8BRtzzCRz170ITGYYplPbxtcX03EZBdhlPxtgELJAcnmmEBSdz/pDR9cUgg8qqs=
X-Received: by 2002:ac8:7f10:0:b0:476:8f9e:44af with SMTP id
 d75a77b69052e-48dfffb6db9mr101038081cf.29.1746446771515; Mon, 05 May 2025
 05:06:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250503132537.343082-1-thorsten.blum@linux.dev>
In-Reply-To: <20250503132537.343082-1-thorsten.blum@linux.dev>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 5 May 2025 14:06:00 +0200
X-Gm-Features: ATxdqUGxKxrETQJZQnYyYx85TEL6U7n-PHMB2aUuzi2Lu_9JVdkOGXYmRq99yto
Message-ID: <CAJfpegu9rjyUWy3920CgJagdJ14X9SrrCcs3P7TrQvYkUah9VA@mail.gmail.com>
Subject: Re: [PATCH] ovl: Annotate struct ovl_entry with __counted_by()
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Amir Goldstein <amir73il@gmail.com>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 3 May 2025 at 15:26, Thorsten Blum <thorsten.blum@linux.dev> wrote:
>
> Add the __counted_by() compiler attribute to the flexible array member
> '__lowerstack' to improve access bounds-checking via CONFIG_UBSAN_BOUNDS
> and CONFIG_FORTIFY_SOURCE.
>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Applied, thanks.

Miklos
