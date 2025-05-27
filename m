Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7AE15A858
	for <linux-unionfs@vger.kernel.org>; Tue, 27 May 2025 14:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748357352; cv=none; b=KKRCGS/Ui4Vq34RZsNDx10wObktA0OJ0FckKpM9aRhtEhcNTdcRkDBtuXFxH067VIGKTUg7BszcFnlGjMxZWEyAz0w6ZDw98e+TsYcu9R+evTxR5qQxN6zPmzBv0oh6v2ax7NfYj+BoLcDW3m83U5/K2I4zQ3xkHKn7gKShflxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748357352; c=relaxed/simple;
	bh=sAiJI1O4JMXS3CTzVvXhahSMi3q9NSOWIzU1NDbfOSE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sDzzBQIDdqaBVcZaYyyWONIKhFgQi74JbdV43c1I5HU/eMQ3okpQvazk9DdP1jaUW46pBAjvhbri1mjhtVzwiy4dYHnDLTdqR6HxFTwy5wZB0yX4YvEGGGB6hT7Hhv8/X+5GI8+mvX+tuOWKrxsyVkrQukn0Tgq9al1H6TscsJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=iGEM0vPJ; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="iGEM0vPJ"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4769aef457bso41684711cf.2
        for <linux-unionfs@vger.kernel.org>; Tue, 27 May 2025 07:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1748357349; x=1748962149; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sAiJI1O4JMXS3CTzVvXhahSMi3q9NSOWIzU1NDbfOSE=;
        b=iGEM0vPJmD4U7evlqR7S8a1CMzylkxnMdnBfO9XKzvO9UzGS9aMEYLT4YH/cbaxEq/
         ICkpRNHzoDxELEQAE7GbVQk8nisy1vbIjtIU1tISofHinamqt7iW8rX2fqBJA5tG6S8p
         3TuTzS984X0lru56Shial6sXOhsZk8/DyWwV8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748357349; x=1748962149;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sAiJI1O4JMXS3CTzVvXhahSMi3q9NSOWIzU1NDbfOSE=;
        b=fDouZx/7+kUaRNcslmGxEzSlsgLiH9vNpc8I8DoAOamZByI5KEx+z7IHmGDwP3NPzK
         HOih5APOhPtdQ2NFKZu/e6wnGjyhjn8Pygaxh/FPNhdGoVf97hBFT1/y3BntEGNnz0+a
         GO+Vt3BdtuAuatL2YjgMruTxHSK+NTQKSxnveI4ZtsSRvODFknjE/WfqOHuMOlHN67HD
         aH2goLjx0nTX+GwDGAeXF/MYgzCpon5ES+q7WZuGT5QwmaDBpoFKCn6h6Uf5bEhTVv8Z
         2OVk2EBULAfjOntqtXQNobSpU+qbS1lvn7AWetHHCeY0pjonH3cQfi4gyAli+zGUiB43
         KU1g==
X-Forwarded-Encrypted: i=1; AJvYcCXOW2CdlZIuVBmnte7+AAP8tnS8/TOqe1gWSDolRhui7q8bQoX1fo4p6Fz3aVWJynASMIjVJDgSoTTcXoaE@vger.kernel.org
X-Gm-Message-State: AOJu0YxBaFnjwAB6SWCaPzVTtaqX3nQY36gBv5RJvq0g0Q8j3pD8CoLc
	xRLh7wjOsCqGea3l9ZACz0NjD3ZM9vd/sBZgpvjl87KJDKyGC+QKbDCaP8mu8fFnBS0CnPYnj4L
	yzYsPPFSZOu+u0gGiPAC04+vogrsbrz3721EsKpGN/A==
X-Gm-Gg: ASbGncsQswSKwXsD3nIJz1+2sm5CgUkUZACBhalrU4B0Vv1GiLBSubC1ShUzf4m+4Z1
	1JEzEatSzCPFsWGaV+cTckIlv68WXZwGqTEoFDJ2GST26gZXgqtKV8pOUCcjPQA0kMLCV5IHNsO
	tdVk14Pw3c4wA3+bT4LQp9CmhAABpZEOpMLrc=
X-Google-Smtp-Source: AGHT+IFKdB9PF1d1KvdjvhT+vpEtaK2jXUaSke16US5DJQ6ZKruJPm+x+ZTCVDhpG+EeSm2Ngd+vuQwEm1YhT98hRqo=
X-Received: by 2002:ac8:7dcc:0:b0:4a1:6656:16f6 with SMTP id
 d75a77b69052e-4a166561786mr115084911cf.1.1748357348899; Tue, 27 May 2025
 07:49:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250526143500.1520660-1-amir73il@gmail.com> <20250526143500.1520660-2-amir73il@gmail.com>
In-Reply-To: <20250526143500.1520660-2-amir73il@gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 27 May 2025 16:48:57 +0200
X-Gm-Features: AX0GCFs3VA7UJtczZg8oDvYBTyu2JNhge9dyhvB1RX5a2h1bXGDJo5UYxG0WVm4
Message-ID: <CAJfpegtYTpJXYOiyckcfQA=YTVXcLQZRGV4=sjueLenJpTp7Lw@mail.gmail.com>
Subject: Re: [PATCH 1/4] overlay: workaround libmount failure to remount,ro
To: Amir Goldstein <amir73il@gmail.com>
Cc: Zorro Lang <zlang@redhat.com>, linux-unionfs@vger.kernel.org, 
	fstests@vger.kernel.org, =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>, 
	Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 26 May 2025 at 16:35, Amir Goldstein <amir73il@gmail.com> wrote:
>
> libmount v1.41 calls several unneeded fsconfig() calls to reconfigure
> lowerdir/upperdir when user requests only -o remount,ro.

Isn't this a libmount bug then?

Working around it in xfstests just hides this, which seems counter productive.

Thanks,
Miklos
