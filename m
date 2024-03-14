Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBEF26BFA0
	for <linux-unionfs@vger.kernel.org>; Thu, 14 Mar 2024 09:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710409127; cv=none; b=h+2WnbJC6V+pKWs3ZKn5oFOZeQ08K9xeN+eySXCQvStjVQseqlRlOF1g9ZZ//4VE31bFeoWrxKYkHPc7PpJR/k3TtDOmBaKBNrsMdisPghr3dj22Ib0EBUpfUIOY5+tem4NWd+3yBroYFV4c9+W5FvVA9ai1nKOunCXMF5cVLOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710409127; c=relaxed/simple;
	bh=99jdUBguX0rRbr0EjMK/qjwxyH/ALk+EX4vPa6MmEgM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BFYy0wR8FT/Zm1o2evY96GnESXk8XcmL4U8s0GoLI0G1wOy5wsMz2of7OjME64BY1pcm48OKUgx1lMjYh0Fgo6Gb+DkOWX2d9IXkR7VI60jtZ6fYzXQ52l0cKf/xAaERJ6U0IDixGc3q53oGNlzMjHk3MLtccJQcnPTNyW5/XAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=DoZKLHqH; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="DoZKLHqH"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-568a5114881so169584a12.1
        for <linux-unionfs@vger.kernel.org>; Thu, 14 Mar 2024 02:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1710409124; x=1711013924; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=99jdUBguX0rRbr0EjMK/qjwxyH/ALk+EX4vPa6MmEgM=;
        b=DoZKLHqHJjKooT7J4OCNGXuI/f8GMQXmFpBykZY+/C9fTvXOxcZEKiAoTGt/S8rt04
         yxflKBrpFbGo4FKn4+nrwDh3K8LqcvIb/i5CNcJ5XH9fYGyxa6FPxk/GA2O5zJMNaEBM
         KJnoscu1Y1vxqItcha1CJPd/4AY+j1q8B+PKA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710409124; x=1711013924;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=99jdUBguX0rRbr0EjMK/qjwxyH/ALk+EX4vPa6MmEgM=;
        b=AQ5Ug6l3TeIqBNQGrKhT6EIlYe4uG5Vg9gklzpP4yJbDGYkN2oj4gSehuOlMapQ1MO
         7fpWkVHQlhZYlPXcOX4X1IohpHqKcLenDxKuIHrJ+fh0PMRgigTglvp9o/aea3U1pJ3z
         2uAUsMCtqCPaBUsP+dybXRugI2+jOhLT0KYx41SO4O0fw+Kz0UPBpASjq3CLRq5njoS6
         e3Fh/+NFh0GIKU5CQst0xgGF/OdAwa5Sddta/uitXagrVvLqswL87fFNspTAYgYjYmJ8
         /5bIbffhJT+NRn0fM8InT1DGQEvEypVe/ImDzthWqCgX1gbW59sG19XHDir+y8Y0fTOj
         RtqA==
X-Forwarded-Encrypted: i=1; AJvYcCWDyO0mnJG0LTTLwuSqPghdeVfY68G4kI1+QNrLYa3tDPejeJZks9iTv2aIcfeb7SIDPGw6JXisITvec87QE578qkCU8nXfIfHNOvJAug==
X-Gm-Message-State: AOJu0Yx74cWY/fY7+3AUUi2x/iN7LBRYGuR6J35FftNg6DzZ8FJiTczc
	zg9vXQ15pFiMcm56Jm/4urDKi+3HpqaXD42RGGzFyqm+dpUBV+usKCg0oAio/dxaap6PyWW+qX9
	HJWwn7G4v9Ld4iuVpbscS4xOTI7mSF2lnypJb/Q==
X-Google-Smtp-Source: AGHT+IFJydnHavfoQj7GUYh55PHRwLEm1dCHo24SSZNO/gRuXbw54y6GXsBk03f130OZZShAe0+mXoV5Dw6q3SS+Q8U=
X-Received: by 2002:a17:907:6b88:b0:a46:7183:14ff with SMTP id
 rg8-20020a1709076b8800b00a46718314ffmr827861ejc.48.1710409124273; Thu, 14 Mar
 2024 02:38:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <00000000000043c5e70613882ad1@google.com> <CAOQ4uxjtkRns4_EiradMnRUd6xAkqevTiYZZ61oVh7yDzBn_-g@mail.gmail.com>
In-Reply-To: <CAOQ4uxjtkRns4_EiradMnRUd6xAkqevTiYZZ61oVh7yDzBn_-g@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 14 Mar 2024 10:38:33 +0100
Message-ID: <CAJfpegu8Rjj1cHkB6JD=TY1CWuVaH8YpSRLQe0cOfG9aQXj6Vw@mail.gmail.com>
Subject: Re: [syzbot] [overlayfs?] WARNING in ovl_copy_up_file
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	syzbot <syzbot+3abd99031b42acf367ef@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 13 Mar 2024 at 21:55, Amir Goldstein <amir73il@gmail.com> wrote:

> The WARN_ON that I put in ovl_verify_area() may be too harsh.
> I think they can happen if lower file is changed (i_size) while file is being
> copied up after reading i_size into the copy length and this could be
> the case with this syzbot reproducer that keeps mounting overlayfs
> instances over same path.
>
> Should probably demote those WARN_ON to just returning EIO?

Sounds good.

Thanks,
Miklos
