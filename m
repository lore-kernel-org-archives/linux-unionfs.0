Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704061649CF
	for <linux-unionfs@vger.kernel.org>; Fri, 10 May 2024 11:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715340240; cv=none; b=M17qj65G6jWBGHMDC1ehwH6AySp4PNH91WeznYf57cNikIBf0aTGANaD30fRFiMBOU28GpBHFLuHqWiXbyNd4uXny1iQF+6ifbFDEB6+lFwj9eiqZvRf3dkiSuQjqWWfdLMWosHlfMS4eHCu7w72yJrTdg+ARBP64xMBeX5xI8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715340240; c=relaxed/simple;
	bh=47x/4Pk6TGycDhdZnlbzTMHVd0iRYhoMxpqaHz5aors=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XHz3rdNs/bEitY+UAq9TGRra17R3oe5F7hP+E+5PoSdYDq3cV9TP9liGi2gTP8w/5LTtbOoDFLjji23gD5gfNPPjDqSgQsW96tTaUzoZp3BV0yXXJ7s8QHW1gyZKhU+8wLIRw66eHvbvk5iF5tgPW3J6weGO8JXKZ1XrsoDqi3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=JpYLSKGO; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="JpYLSKGO"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a59a387fbc9so498071766b.1
        for <linux-unionfs@vger.kernel.org>; Fri, 10 May 2024 04:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1715340237; x=1715945037; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=47x/4Pk6TGycDhdZnlbzTMHVd0iRYhoMxpqaHz5aors=;
        b=JpYLSKGOBfaIc5A8kOsi5/Dp2+/FW5QcD3PSDQjxzFhPoThcC9BFnBTZ6bjdLPn1y2
         H3Ciyfq/DoepN2m57HmuLeQcub49JESXoeDmgeJbyvwVncXszisdoYaiKihDJhidJ0fS
         guBqjTh2IcbqsTVlhlUJUWjpelIrxQkrhmoR0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715340237; x=1715945037;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=47x/4Pk6TGycDhdZnlbzTMHVd0iRYhoMxpqaHz5aors=;
        b=X/iyb9+zZ2nRJkb7BNhSafOyopCHhks3Ai7vE52EfhiwDNBwFxjKtA6LT1U84++z1V
         Ylg0hv7qUJDdLeK9smsJ0V5C9v2jWWFlCgHEeyxSoJCRS91+OntD5N7axLCs0L2VmnwZ
         LZG12brlodEgvhUJB6XwPuBTT4fb8V4BXLKspwl8+sOPm10sDsHu0s+CT8qk5J5R10s3
         FMRz5qOSvDJuToC6ToMibHnacan/F3159+5lLL/hjLpJDSKhAWfJ35PsZvHMRyMhDnp4
         S9dfdl8DQ8tHqTxxT+K60SSaWe4bTktp0ZTYFLOCCGXDbodKNiM8O/pZdD/Zokk4qJUh
         cedg==
X-Forwarded-Encrypted: i=1; AJvYcCUpU8Uhx7FgsgVqTg7c1rrowpRx4il+DaoJP+1zIEtkN6i/MxaGzQ06tKtks6Gl9QsnEFm7xJwh5zgUUXKIJcP3RKmLDiPPcu17/b8ptw==
X-Gm-Message-State: AOJu0YwE4/vwL7Xvpa6PJG3MIWniRpcn2La4hFGEMn41Kxcyng2gEMET
	wVoFpNc3yKCNVB2EDbSxl5V+speYSmT5vGCydLhK/1tvGBdAjl8jkcwore/8z2IbxB8y78Vqwz3
	+9r2IjPVPtZtNXJmPwMG/FQBqEJxHS5acBy3amw==
X-Google-Smtp-Source: AGHT+IFz5qP18mAylhBbmtThupMzDKv7Hxf/YKoxmcI8024bWwzwHlVosWJHVpjswkQo1H6JZ+uOIVvInsfVrUzL8aQ=
X-Received: by 2002:a17:907:26c9:b0:a59:ba2b:5913 with SMTP id
 a640c23a62f3a-a5a2d66b525mr199596766b.62.1715340236873; Fri, 10 May 2024
 04:23:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240502212631.110175-1-thorsten.blum@toblux.com> <20240502212631.110175-3-thorsten.blum@toblux.com>
In-Reply-To: <20240502212631.110175-3-thorsten.blum@toblux.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 10 May 2024 13:23:45 +0200
Message-ID: <CAJfpegsVWa-fu=DePSC0J1WkfQxhaqs0RTxopMBHduwMANieyQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] overlayfs: Remove duplicate included header
To: Thorsten Blum <thorsten.blum@toblux.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, 
	David Howells <dhowells@redhat.com>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, 
	Dave Young <dyoung@redhat.com>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netfs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	kexec@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 2 May 2024 at 23:27, Thorsten Blum <thorsten.blum@toblux.com> wrote:
>
> Remove duplicate included header file linux/posix_acl.h
>
> Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>

Applied, thanks.

Miklos
