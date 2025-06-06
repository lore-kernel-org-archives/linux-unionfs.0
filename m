Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7EA259CBA
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Jun 2025 06:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749191795; cv=none; b=NMnUI/We0CteNGfkCdzOd+MDu3ZlwfWHjKIyBcyD88BI6vlvH2d9Ag76288B+mqMSddY5RFVlFqLmwRNPNBCqQ4ApE+NuBYapRmKo+cr1TJ9TY0rou3J2K3QPRrNm4/if+WUHc0sczIuwMHtMUpKIhFDM3rU0C+YUijxJDcEBVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749191795; c=relaxed/simple;
	bh=toV9IQaPqvqASnNJNFj5X1N4rgKmvC/sEVmE6pwDqZM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XUkNzHMknXO9/tDL2ZZ8zzrdaxEXac/HmrFz8nMc2jkWuE3xKl+CzpnqgR85Qvz/kNxR91KpeszKBS68Pkqt4vPdpgL087zIxsD9tpn2k43ii5lOKo8lATwy5etzHJKfTJuiUfv0Uybh6nfdK5KUgOITOrEypUQ5mZWH1uTWP+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=m5l66cIe; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="m5l66cIe"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4a58d95ea53so20551821cf.0
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Jun 2025 23:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1749191791; x=1749796591; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=toV9IQaPqvqASnNJNFj5X1N4rgKmvC/sEVmE6pwDqZM=;
        b=m5l66cIe9Ks66bsumCP3uFTyW71mGCI1gMLaSqBbgW/qPxRDwTCLnzvcfTHk81mzJm
         lMIOxN2M6B6J5E39IJF2ui6dK8T8pxUdpTPQZ9gqjJZO7RPpwCWvmcKMpipdDp8gr+j3
         9hokVjeTs4s+lXPh+fdHeXK0/qfL0c4fPjL1s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749191791; x=1749796591;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=toV9IQaPqvqASnNJNFj5X1N4rgKmvC/sEVmE6pwDqZM=;
        b=VY5kqjTdac2ZqZGdpqY4BMG1xslyUudvWqXO45JGjASA6FOh+m5KlEe7RsTIKZOGm9
         l4YIeL6a6rCpCogNUQn6ctLjxgwGO2rxZ9kX2Axwy88DJa8au/s94h5tKPKZtvzxWcZL
         kZUpxuR2nvQKJwR+dCA3IjsYbfv6Bw6KxwhIik/cKXqqy3lpQNP1FHEYX0Pm7/PWDpAF
         DyI4Or8uM+Hzgo/CfKGalMLKxnXlLsPiA5+OlQIvkbtpuXskc7TnNnyYAATr39m/M2WP
         i4u2IKqW0es+V3ura/HEnOB8hczP+mhCCoHr5CE9xlBuk6xSHPgpT3Uiq/cxsbWiJTMx
         E6JA==
X-Forwarded-Encrypted: i=1; AJvYcCVuniPWxUEn7hBSv4sE+aYaOWdM0BpDgCFztXzoOqAxePpSexhZyDn3OhuA9Ahu3eWVYRHZHGvOYEQ+JJuY@vger.kernel.org
X-Gm-Message-State: AOJu0Yzdt1ZwpQo0R4MHh8tD9HBv5n3nO0U9Vp8l/9ydwRN+oSuvrkEH
	aTTO1yEpQ0NV7m0rK6VcXznrdmDF8bFry8tbKZ8/+xEZsKct0Ca9ckPOR68fTIYBNNUKie4oZAA
	bZ4Jy/z1HFkj13Br+0o0KsRKnuiH1CdWBCJpx1T81QDR1L0QJLPVh
X-Gm-Gg: ASbGncv/vHIzzgbegCkUle20V+4oXYIIn30SOrHYlitxDRhu0M+GCoUjqvlfFSegOe1
	ilXb/sOcKJmztGv/tbv9I3nEc/JrgedpS2YwvY95SX/QS+ZiTFLbzgCHRxsBik6J7XsDp9Offj4
	ipZqp4O/NZxYLoiSNweCAExBE7hvocmCDdrGTzY5PWPQ==
X-Google-Smtp-Source: AGHT+IHZrb8oAUUqWQq5BNm3Ul6xtj6V0TOzDYLhpLP/ffaA9kQ6VFwAI96cX+m2oJJdGnfs/tFQhr6ii63ncKo6CfE=
X-Received: by 2002:a05:622a:5148:b0:4a4:2d6d:80a0 with SMTP id
 d75a77b69052e-4a64b6511admr22914341cf.10.1749191780124; Thu, 05 Jun 2025
 23:36:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJfpegvB3At5Mm54eDuNVspuNtkhoJwPH+HcOCWm7j-CSQ1jbw@mail.gmail.com>
 <CAHk-=wgH174aR4HnpmV7yVYVjS7VmSRC31md5di7_Cr_v0Afqg@mail.gmail.com> <CAOQ4uxjXvcj8Vf3y81KJCbn6W5CSm9fFofV8P5ihtcZ=zYSREA@mail.gmail.com>
In-Reply-To: <CAOQ4uxjXvcj8Vf3y81KJCbn6W5CSm9fFofV8P5ihtcZ=zYSREA@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 6 Jun 2025 08:36:09 +0200
X-Gm-Features: AX0GCFs7rakD2EWiToYlZOoJVn9Hy1NZM9uDDVwqBk67n4xvc5_i2D2NHsaiR_k
Message-ID: <CAJfpegutprdJ8LPsKGG-yNi9neC65Phhf67nLuL+5a4xGhpkZA@mail.gmail.com>
Subject: Re: [GIT PULL] overlayfs update for 6.16
To: Amir Goldstein <amir73il@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 6 Jun 2025 at 08:17, Amir Goldstein <amir73il@gmail.com> wrote:

> IMO, it would be nicer to use backing_file_set_user_path()
> (patch attached).

Looks nice, thanks.

> Would you consider pulling ovl-update-6.16^
> and applying the attached patch [*]?
>
> Thanks,
> Amir.
>
> [*] I did not include the removal of non-const casting to keep this
> patch independent of the ovl PR.
> Feel free to add it to my patch or I can send the patch post merge
> or cleanup of casting post merge.

I'll redo the PR with your patch.

Thanks,
Miklos
