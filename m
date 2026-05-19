Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615C53BCD21;
	Tue, 19 May 2026 15:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779204405; cv=none; b=sJec1nXZ8KE66eaA3KBQZ5aLaAbMxQTlpyxtPOWrxxuilPdIravase7HHghh8GRRjQwNp0lDR8TVgrNeUtt6XETwCGZ01Q78JSFieH0yxS8mUH7AJOIFMmT3AxVF8bgXnPAV0bMteBrrJBBlQxpFiMCwsvMglI5bPF6dsTIPiqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779204405; c=relaxed/simple;
	bh=Y+mO78+eiJzVMo/DBt3dF9ogCY+505sDv0YBXdFC8EA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=mrnXDowO7DmEQe2jaPYi5HpnvV8PRoHCnhMbaAT35nM/VCp4aSGMkDhhdhk/sEla08IMO66SYtCz6sHdKBpnrgYf4zl3E9N/E0yvrPBJXWPbnaU7XUG3WCv4QVB6R3sr1jPt3w1MwbmAaWtJAPP7sL8H0kBsJO2vUMLaaPMyjbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=m2a+Lie3; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="m2a+Lie3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Date:References:In-Reply-To:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gV6FyOwKx3ZNonpcPNB6JPd9k/XUYewGLxuLhccX7NM=; b=m2a+Lie3iR7vHl9WAxvhTwibvG
	OQtCMpTNHWsv2JEXHh+ymGlAC0ojymMq0PZDIzl/Ewb0cuotlh+NoJ3P/9EGvVbY14SShrRypYcUD
	OecsTEHcWzekBvEs7FyJyKwt40+ZSYqVr4DcsoucmIJBz39p2x6inKxW5A+QMQSETuypHhEgL63vY
	eKs+lpopMeuYsD0A5zU09bFByPO8qt6qnkmDX47F6x2H7KtaRHjhuHsr0qDXAYEkFQ5OY3wxDE8N7
	VHdiZ/CVEf2cYCXxgjPQAoZnMLF5VqoQi/VGtBPHgbRsFApi7eBNeGlU2G1tFnDLM2HYjJitqHDo4
	4CEf8GgA==;
Received: from bl21-120-122.dsl.telepac.pt ([2.82.120.122] helo=localhost)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wPML6-003FFa-Ia; Tue, 19 May 2026 17:26:36 +0200
From: Luis Henriques <luis@igalia.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Joanne Koong <joannelkoong@gmail.com>,  Horst Birthelmer
 <horst@birthelmer.de>,  miklos@szeredi.hu,  fuse-devel@lists.linux.dev,
  linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v2 12/21] fuse: add struct fuse_entry2_out and helpers
 for extended entry replies
In-Reply-To: <CAOQ4uxj+ss82jZV6yq=LXag2s_ax9rVdtH9uc8W+RnRD+U5qpg@mail.gmail.com>
	(Amir Goldstein's message of "Tue, 19 May 2026 16:17:51 +0200")
References: <20260516004004.1455526-1-joannelkoong@gmail.com>
	<20260516004004.1455526-13-joannelkoong@gmail.com>
	<CAOQ4uxjMPPp-R37yKoOs1kGUdAOmnp3keVWvfuxi1r8jrxAcTA@mail.gmail.com>
	<agjDGBQPG2WpDTWO@fedora.fritz.box>
	<CAJnrk1b_55hMTRxtV8QKBqdfEhT_LQK2byat+x-a8Xrj4nicnw@mail.gmail.com>
	<CAOQ4uxj+ss82jZV6yq=LXag2s_ax9rVdtH9uc8W+RnRD+U5qpg@mail.gmail.com>
Date: Tue, 19 May 2026 16:26:28 +0100
Message-ID: <87tss3ifob.fsf@igalia.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


(Sorry, I'm slow catching-up with email :-) )

On Tue, May 19 2026, Amir Goldstein wrote:

> On Tue, May 19, 2026 at 1:12=E2=80=AFAM Joanne Koong <joannelkoong@gmail.=
com> wrote:
>>
>> On Sat, May 16, 2026 at 12:29=E2=80=AFPM Horst Birthelmer <horst@birthel=
mer.de> wrote:
> ...
>> > Hi Amir,
>> >
>> > I see there is a lot of talk about using the compounds in a couple of =
different contexts.
>> > I really have to apologize for not having the latest patch ready by no=
w, but I'm
>> > a bit unsure how to do it.
>> >
>> > I'm not entirely sure if compounds will only be a thing for fusex or i=
f it will ever
>> > be accepted for the classic FUSE.
>>
>> I'm not sure what the plan is either. I think this will get clarified
>> on Thursday hopefully.

From Miklos' email "[post LSFMM summary] where is fuse going?"[1] I
thought the plan was clear: both compound and file handles are going to be
in fusex.  Quoting:

> COMPOUND REQS: let's add this to fusex.  uAPI is simple, kAPI needs refin=
ing.
>=20
> FILE HANDLES: same: let's add to fusex.


[1] https://lore.kernel.org/all/CAJfpegvXnA1QpmfM9V+3VB470xYDNWH8FV0mBV1R1-=
HqvjfJ8A@mail.gmail.com

> Wait, is there a FUSE call? I did not get an invite :-D

Don't worry, I think no one has yet received an invite ;-)

Cheers,
--=20
Lu=C3=ADs
