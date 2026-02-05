Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6BE399003
	for <linux-unionfs@vger.kernel.org>; Thu,  5 Feb 2026 09:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770284753; cv=pass; b=UWLSDhLQcOmbTFdZZ0bpQl+POt2qcMtLLsEQ4R8IQOFC6b46Vyp8Y8FKksnriwtD494K/lKRxVAXKENY7FRyI42N9a1hQ3qdVoH+ywW83rdehvE/MXp+sh7w1smc+lFZbWJpIslM2YdmbePVEztk9XsSyGuwSCV6L+0WJgRDIec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770284753; c=relaxed/simple;
	bh=gTHjRNg48uqIhlFUjNVy6w29gFOiVNhUd1etS9WljNU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NFsENoh4XI4q5jBQB3HDvxKMotvDVBnRiGnS1zUobp1DuSCw0VvclCKrtNQfvKhPqum2EBHzL61M40Tcz3spUbMPAlgLnmQmrB3RFlrWyRW+vggM7oiuz2w9BRARRDxaotMcHAizqeb0Ib1D5O8YcpWJOSJx0yCHIzT/bdkidu4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X7wZYF6o; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X7wZYF6o"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6505d141d02so1186194a12.3
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Feb 2026 01:45:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770284751; cv=none;
        d=google.com; s=arc-20240605;
        b=he33VYJJiApuVy7i6jWBdge3SzSzQp1UZT7WVpqXnx1d7Wi6KM838bh5DCSYdlwhtV
         Tk5gVAiLUMDpsspirvyjYAI50tflydCRGKuDp2FsoRuEgMWsNcblkW6cdAQ5BV1qhsi5
         2yG6QJX8GWtiKE1hObZoiaz82os7J24YMZJxzIFNw3kBHCtlrlZOUn4Rpwbvxm216Jmv
         thqDvFxU+WcAd03ZFhxhGoYT37mNQ4CFB/8se6By4d6OyvvkbLNl5pbT7awPgPmzgf2Z
         QF0wqkHWqh+MWCZmB53jvmUPEPreRQgz5PSV/F+A9FFltMPVYKsDBYgyGrqaHwmGigk+
         EgyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gTHjRNg48uqIhlFUjNVy6w29gFOiVNhUd1etS9WljNU=;
        fh=dylmR/VI2JamrJ3Cyy9dw199B8DPlxJmEcr15vZFAOI=;
        b=h4SQGIlffPwn6MkAc3F9rObcMgymuV85ReplU83H5ZwfZx//yzMlFqPCYUSGzyT7Td
         gr7ZdXqwZXMoEfLBt4e/n9R0sVk2utpU3UvWPugTq0yO/TfXnKfCHNU2JhP29BSDyImy
         FbOcW5hT/y36TNTL9V58OY+RrhhCLaoLzXXGc+pEFru9xfg3Xb0aLhLA+K54qwad2Y/i
         7bcv3JV7mmWb0PXsB3NzuXpZSsiZmbr8NhC7e4vUBGUCcwyoo9zRHPxr+syjXcyFM8w8
         mtifzkT/98LQK8UVr577lZsouTp9SnqJF3A55dAXx+RP7r1ug/WOHOY9FgBknHKTWxkj
         gUEg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770284751; x=1770889551; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gTHjRNg48uqIhlFUjNVy6w29gFOiVNhUd1etS9WljNU=;
        b=X7wZYF6oGkxVE+gLTBtcX28o4eYBAX3e3P5/p1DkotCtFvnSm+dNdGmggiKQnap9HF
         uJoR8Y/7jQwtGKgtwXZNQtMOcaDouskzI9DbFRdinBwM2G8kpSDc+wVOPd9ayKvPaZtX
         qDZsWavmVfL8txVAZaxKDRyNO2gl3nDKYj6Y08WRzZFoXlLH4OBDdd4dCHPmAv9LaYhV
         aYyqyMoVjKFMXFsylm9qYTAL0LLdTNasCpSpfzLfkc3XzkPNORx9OBQJnvhWeWVvJgyV
         IFPElSh1GAM0WngNDgAYeJbIEwtbP3kxmdE1hnqP1mOoFVug/wkO0WrOFsaHCyIytL65
         aJVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770284751; x=1770889551;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gTHjRNg48uqIhlFUjNVy6w29gFOiVNhUd1etS9WljNU=;
        b=eMoUxuBpRbn5n+5tjCuVChawmHExOk28PqFpkivLsRveEgQOC8XJVJoEWQ9JX2yEVt
         E6KIkGBXqwLJGfMbAr0WCFJIGtmUbuxD+BHm1Q9YJRjnEXMa4DqMnb6KWeR0XACtJH7G
         BkAj1QCh4pX5QqU8W+PdevsiRwqb+GN8C6hEkxRnvXTYLhI2xd27EzNeKMkj043dq2di
         6HHGgOb44DuWHDDsmLIdR4BoQiYHIXd9nRhi4QdqkIKmFa8zllV+qDnU27q+aECuAeA/
         cy2L9SxV1isWY4i89nz9D8IKbTQNjOz3kZeTIBDyMRkTShTLkmUjGFSr08sAdCc1F1eA
         rQOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwnYyaxLO8dAxr55RTZRKlW/wOIrUli1DWHmcWEV2W4a65oxqx40cyauXZZbfsjykLopttIZStKkiu1+V9@vger.kernel.org
X-Gm-Message-State: AOJu0YxSL/yadnXIScSAwpSf4afVKKLEcUx8DPX/xgH5ERyo38ym+RiV
	mEfREm9RyAME0oXBh0x0uScUOxxHx/gEQvgEukyRM12I1JOZJktvgmGJsvvHLKHFTH8mYp6J4g/
	VEPmABaLmlCJPxaVqKxDyMNTelOYCipc=
X-Gm-Gg: AZuq6aIjGyL2x99qZtbDmL8yJ8IfDg8Jg14e2hfEnuEQPjvV7qFiXIMSltI7k8NckES
	NbUFTCHqYxoAB2q5s8R51JYp21cMz/17lQDxRdz+yv5HwIMhvD2Py2a/wofmw6IV5DbqHlpRGbV
	HPYWoOfju1pMLqf3fcZ97AXYs2vgtNZyEMa5VljjnlvNo/RnInNoDGRvpkflPGkdKjfmgKqFExz
	k/+wpu8xx6q/D9qqFVy87IOgMZmX144+AS7q3vHJQCB/iZmHqpf8KXvrcAsuzdjaGKH5rqBEFiw
	/33RSr3Ih9NpeEioYggjHssIqBejpA==
X-Received: by 2002:a17:907:7f92:b0:b87:31d1:4131 with SMTP id
 a640c23a62f3a-b8e9f64603cmr435430866b.60.1770284751163; Thu, 05 Feb 2026
 01:45:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260204050726.177283-1-neilb@ownmail.net> <20260204050726.177283-13-neilb@ownmail.net>
In-Reply-To: <20260204050726.177283-13-neilb@ownmail.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 5 Feb 2026 10:45:38 +0100
X-Gm-Features: AZwV_Qg7CM-kXxjB2Qin-euJkaOUd7ni190R_n_ZLhun34eHr5T-i9uF6CbqXdo
Message-ID: <CAOQ4uxi3bNYq1b4=qL-JLi19hRwurntfLZXhUMVL003NarBdGg@mail.gmail.com>
Subject: Re: [PATCH 12/13] ovl: remove ovl_lock_rename_workdir()
To: NeilBrown <neil@brown.name>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>, Chuck Lever <chuck.lever@oracle.com>, 
	Jeff Layton <jlayton@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	John Johansen <john.johansen@canonical.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, linux-kernel@vger.kernel.org, 
	netfs@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 4, 2026 at 6:09=E2=80=AFAM NeilBrown <neilb@ownmail.net> wrote:
>
> From: NeilBrown <neil@brown.name>
>
> This function is unused.
>

I am confused.
What was this "fix" fixing an unused function:

e9c70084a64e5 ovl: fail ovl_lock_rename_workdir() if either target is unhas=
hed

What am I missing?

Otherwise, feel free to add:

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.
