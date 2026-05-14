Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B50E42EEAC
	for <linux-unionfs@vger.kernel.org>; Thu, 14 May 2026 15:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778771825; cv=pass; b=iTWDYCeN8QAck2uw3jt8Q3Dnpf3mSbPm9cBbvSq4JGi9gorH/kJVZqpZt9LXSF5+nj45lu5a8rHtn3rKdPkqdjwM5BeJuRzJQKmwqGs8b6Fuv9adwfCYfUli4mGphNO3sz5ZgH9k9P9aIUXVYuaVmG2fIdogO+WTllCtSMdIHj8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778771825; c=relaxed/simple;
	bh=dPEdLzpAoisLtNpVvndO8XrxUnyUO0mRm/pzuoHcv6A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ged2m2mkm9yXox38t2NOLPOt4Wg2iuhPgHVJptM9owGfb3hmcb7MHRdY5UOY3ZGoN67JWuWzwjvzxexf/TNMCTDzR1gW34sR9DtFVf1kky7GsRr+nO6r1dxUyBaNyiycbIg5UJGQ1J195nEJI/DO5o6N960wZo5UhbZKGQ0Nq2A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QogrGVwY; arc=pass smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QogrGVwY"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-bd5047a2a4cso97932866b.3
        for <linux-unionfs@vger.kernel.org>; Thu, 14 May 2026 08:17:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778771821; cv=none;
        d=google.com; s=arc-20240605;
        b=CuQs9fX9XBG4Mw5dLHBqBM+9zIyT4N6zT2uqeXVUuUyJIUDEbAbjfW+U1Zie4dVnYf
         yDpldl60g5ljdiZ9qFiw+mN9DSx+d6QqmGOK0ScQED447bOQMCVKAICyHCutqmTGPXWF
         iVcL8w6OrEXRJwB84EpoyVDhHJcRuHPEaHU7In0ONGN6lJO8efRoo8tJBcD7nfvT9vvC
         y0Tt2UrN1mHYa9jy9FaW4ROPmIrG+R+qEZoL818XPwzd7e1TUQMMn0sFvKQQyo2LqzoA
         94GOzAxP/e3kbsOLkKM2Yjax391AqMWQO3sTAcQb7FZsimf9jra9Py1RUKVcQEBJKWFl
         Hn8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dPEdLzpAoisLtNpVvndO8XrxUnyUO0mRm/pzuoHcv6A=;
        fh=Mv6mNb5JDJjw22qu2aSSWfyvpCkx83xIWbNab4yGDrA=;
        b=OEGwHCerCJGEc1detbZ2skh7itEQ1duhjnCF4gvCl2jSZWVEULYrJ/08J2L4KGG62k
         /SSXAEdzZHi8XIlSsebQKL5e92lK2wQTe5jDgvWDKhAbhR+DNMOfn8a/Y8ylktNyrmpG
         JwP2fBvXPObme3b+9Ri9CUVQRClF0StEBA616rqU1tGVR6X8wDfk/ecai+kLF2OI6F8f
         f7yv/+SYIvzmTXDo9nNZrlE4cds1TEnmT1DWpMlxOlFQitJgTPonsvGADgS8L5D/zx9m
         L5mPsFB5/GzuC6NUw2Obrl/NIbXusci9i2QmYNhJuYdR5+Z6Ci+gRkir6HMO1MzDyc3D
         tGvw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778771821; x=1779376621; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dPEdLzpAoisLtNpVvndO8XrxUnyUO0mRm/pzuoHcv6A=;
        b=QogrGVwY1gn1xnrBUpn3/cnrp01fvNYLDTAsaEnKo6tPIhTD77EmemXbtRb8lIS0XL
         yG6zzwGQ3/7+SxTksvDzYpE7KNacDNZFi4a5KH0/FdFq7cRCEG9rAvY4TmV9DYAUG94C
         Ukm/ToBvWtYpitpCaIB1OZdb1juFjxiZMzkzDzjeKx1Nz0yhO85zlx/AIcgucDEj7vVL
         k/dAyaH5W+1VpHHOixrwk+GPM0AZQJTFVSxlj0toPiDyqVUaBukzWCNM0sJPLl0x+Olo
         CIi7VMzGNslQ2OK4O4I/bWpHUH4oEv5h8mkCUjH7k31kK05RCyUvxI7Bbiyp7Ty1dkXV
         uiYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778771821; x=1779376621;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dPEdLzpAoisLtNpVvndO8XrxUnyUO0mRm/pzuoHcv6A=;
        b=bXy/qHLUjUzxMgHyp1bjDDrdTtGRjKZqsM376b5oRGV/UkBRyewWhsN4bEo3ribWEY
         gmrxw/kj4O9N6KW37j2TJEe6KSMdgwFPJCTXklay3K4DprADPfONQI3PgdJwLM4k6Khi
         ihQ90jUwjX7Bs6MctXKApbYPaucI9M8oQ971L4A2iiC299Nfs4sl7r4+XM5hm/sc8ety
         /iw7A8sgogghWwcjXXo8CSJK1Bna5RAd1kd0LFRz0zC9brd2AfQfEEqdGPFGJOaeAVdT
         W/uRlxcgLQq4lfWKTkjfIsLUPi3lBV71pQmKzOU3DQeTenAkET/UFZaOuLXyRLAONBxx
         YikQ==
X-Forwarded-Encrypted: i=1; AFNElJ92YYTKvYqagHNRyDB9xQ8BNvMlzpSYXM7JMc1X4IrEewxkzNi8UE+jpv28vrkiFS/Yfh7Wpmt2uE5aBTTJ@vger.kernel.org
X-Gm-Message-State: AOJu0YwrEQCJJTN92U0lsnf7LxOVcULYiiU4SaOsk16mH893G/lJ3pHp
	Qoz2kB1op/EDiyiVz5cON0GHvXWNtSCcwBinLOns3aXucZ/lvzCid7IzZse6g68dpxk3tQqFZt9
	UkD4/dGIymc2lapzQz7I7VAUXspHnUyQ=
X-Gm-Gg: Acq92OHhiA3X3UmJ6mT+lSTLSXspd4RXszQKlBYsKYMmHNhUBNImU8RoWqWjknVLgxA
	QpniNfN8GjlL2ZdajYhuC+eROKQDte8pv4NsbsehTOdhWeIfGUmZmg/9/mzdgeNZ1xXASqluL3T
	pc/jOVCrNOPnaywJM94JO4hhqaByAhmNqeC+asQ757SuV/lUlle6CM7J39AchmF9yOBOtItZA4g
	H239bbwVhQIfDdRsUnjMofQl9droghMRkGY325seXsQcP2Sn96WFnd794/Kr0L+CLHdEJUevLT+
	B57MkwCaE9jLDthS/czq8GUfNH+momW5/vTflBmvqQ==
X-Received: by 2002:a17:907:971f:b0:bd4:1bdb:1e5b with SMTP id
 a640c23a62f3a-bd41bdb3a98mr530768566b.27.1778771821338; Thu, 14 May 2026
 08:17:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOQ4uxg+DkTuinnf9AMR6gdHqAydbD88+oBkTtQtABJfdC0vVw@mail.gmail.com>
 <20260514121336.439565-1-nirmoyd@nvidia.com> <CAOQ4uxg=gONUh5QEW5KJcyXLDF15HbLnc9Ea7RKPcgtyfPasTA@mail.gmail.com>
 <f9f0e951-a52d-4272-a44e-890d7e7555fa@nvidia.com>
In-Reply-To: <f9f0e951-a52d-4272-a44e-890d7e7555fa@nvidia.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 14 May 2026 17:16:50 +0200
X-Gm-Features: AVHnY4JwoSSd2cEfirUZGC7RWx_G-jzc2_ansVS0y4dNwHY950Icyg1WXbaO7SE
Message-ID: <CAOQ4uxgRzcSCWWq=eGfSc=iUOs8k_eD1_OKCB_sh9Vc9nSQuOg@mail.gmail.com>
Subject: Re: [RFC PATCH] ovl: keep merged and impure readdir caches separate
To: Nirmoy Das <nirmoyd@nvidia.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+a16fb0cce329a320661c@syzkaller.appspotmail.com, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 14, 2026 at 4:55=E2=80=AFPM Nirmoy Das <nirmoyd@nvidia.com> wro=
te:
> On 14.05.26 16:09, Amir Goldstein wrote:
...
>> Patch looks great - real root cause, gave you minor comments.
>>
>> IIUC, as far as you know, the repro never triggered the theoretic
>> OVL_WHITEOUTS race?
>>
>> It was always just this ERR_PTR(PTR_ERR()) black magic?
>
>
> Yes, with this particular syzkaller reproducer, it was always this black =
magic. I tried with and without your suggested changes and saw no differenc=
e in the crash behavior.
>
> But I think we should also have the fix for OVL_WHITEOUTS race as well.
>

Yeh maybe.
I don't like making fixes to theoretical races without reproducers.
I'll think about it.
Maybe I'll try to reproduce synthetically.
Or maybe I'll just do a fortify patch.

Thanks,
Amir.
