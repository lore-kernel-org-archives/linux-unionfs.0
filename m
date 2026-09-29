Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EA13DAAAF
	for <linux-unionfs@vger.kernel.org>; Tue, 29 Sep 2026 15:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790696126; cv=none; b=tyexKcW6D1ZDJfz9deSKtfTAxUvL6I6YwYxn+iQBfJg+Eh/dWvTZEn2lXFQ8IHhTC+a5/C0wQqa/4HZik7IdNbamYRzVo9CWhFN8C2RXvsi3r7UgWB1eU9Rz7Nj4hH/XugGxTCBgGF0G3yFReXmUtnN55ex92eaebUWnTAJO4XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790696126; c=relaxed/simple;
	bh=NCwgTAxyTUQwY75TVp+kWH1Jkd0gXgr3HqPSTeusEJg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=CGuq69toaQGRk84f5E9sv1drj/EV21Huq8mocdXoJstz532bAD3xsUt04kt2YBk3rM+45Z8Qn3KdOk5QO77ZAkIlKBwK+fpzK6XEoiUDEfFpFms3LuKfIhhA9uabrHybcl09fRZPPxMuhWKdXIayXE4pBtN7LHz4/n9X4leU+rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BvDyLXUQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=aGjaaqRn; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OCgd65Hc; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rUuRO2JE; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BvDyLXUQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="aGjaaqRn";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OCgd65Hc";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rUuRO2JE"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BE74A21DA4;
	Tue, 29 Sep 2026 15:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790696110; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bgCIe29fZ+5xH49B4VEfi+E+Krs4iRnCTa3+DRXXnsU=;
	b=BvDyLXUQEKOGEmmc7ABTO2Ab1MeHkFQs6eRhvrTo2mv+85vXvxQbPIupfN0klUfeud27z/
	n1ict7cfP4H/beOYMkLPc5TrpLEkL+99h39AD8XQCVTLSkJ/vcR4WD8tvD+9hpJomelbcB
	+HpvYhMtG7ZSj7dCN79u8sc+crSfJng=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790696110;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bgCIe29fZ+5xH49B4VEfi+E+Krs4iRnCTa3+DRXXnsU=;
	b=aGjaaqRnIbkSxibQRfUrlU77mFAX5Hu9yUsfgBrzXQeh6DyqajLxiKuwE8ISV9Wbe3rFwz
	GaCR+oaHprWFqICQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790696106; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bgCIe29fZ+5xH49B4VEfi+E+Krs4iRnCTa3+DRXXnsU=;
	b=OCgd65HcH9IRQ4saD6ZiSUkH+3eIak1dcIu4ZXAvMIaW/smQjsPBeCoEd1XpdDtaXvrgbD
	OA9KmHtVLkQZCeVS6nNDaV+JL0yG90ZGjOlZMbvcYP5XzegSWPiE5GSEt496LWwItpoESH
	MScSlPFhlwi+KzHY9gkQajObTK9ulT4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790696106;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bgCIe29fZ+5xH49B4VEfi+E+Krs4iRnCTa3+DRXXnsU=;
	b=rUuRO2JEncH5woRLbU/2tZDBOq1hmwYAJhQJW9r+6UUcj5ToyWB/02Y0cCarpr5067pN5u
	tCBYKQerH33UJkDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4BF61136E4;
	Tue, 29 Sep 2026 15:35:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gN/3BKrau2oKKAAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 29 Sep 2026 15:35:06 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, Hugh Dickins
 <hughd@google.com>, Daniel Tang <danielzgtg.opensource@gmail.com>,
 linux-ext4@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
 linux-unionfs@vger.kernel.org, linux-mm@kvack.org, Chuck Lever
 <cel@kernel.org>, Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>
Subject: Re: [PATCH 4/4] ovl: Expose the filesystem encoding through sysfs
In-Reply-To: <CAOQ4uxj7Vx-UGvgGGr9hPC0qUgJZ_WRAv1ZLi=gJ6r=ZJW0QAQ@mail.gmail.com>
Organization: SUSE
References: <20260928213155.2612039-1-krisman@suse.de>
 <20260928213155.2612039-5-krisman@suse.de>
 <CAOQ4uxj7Vx-UGvgGGr9hPC0qUgJZ_WRAv1ZLi=gJ6r=ZJW0QAQ@mail.gmail.com>
Date: Tue, 29 Sep 2026 11:35:04 -0400
Message-ID: <87mrt0xe8n.fsf@mailhost.krisman.be>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,mailhost.krisman.be:mid,suse.de:email];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,suse.cz,mit.edu,google.com,gmail.com,szeredi.hu,kvack.org];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo,mailhost.krisman.be:mid]
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO

Amir Goldstein <amir73il@gmail.com> writes:

> On Mon, Sep 28, 2026 at 11:32=E2=80=AFPM Gabriel Krisman Bertazi
> <krisman@suse.de> wrote:

> I am not ok with this API.
> It is wrong in several ways.
> It is not generic, we have already file_getattr() to get casefold status.
> There was a suggestion by Pali [1] to get the supported xflags - statx st=
yle,
> which can be a way to say if a fs could return FS_XFLAG_CASEFOLD.
> In Chuck's v2 [2] FILEATTR_CASEFOLD_TYPE was already suggested
> as an extension to file_getattr(). I think we can still do that if we inc=
lude
> proper versioning in the casefold type.

Ok. I'm not fond of the overlay part of this series at all, in
particular due to the major:minor design.  I was looking for an
alternative way to do it and didn't find it, thus /sys/fs.

> TBH, I don't think anyone requested this - you only mentioned
> the need to know if tmpfs was mounted with casefold on and that
> doesn't mean that etx4/ovl patches are justified, but ext4 can decide
> for themselves.

There is a need for a proper probing API when deciding to fallback to
userspace casefolding workarounds, and that is not shmem specific at
all.  I'm sure the Wine folks that right now use ext4/overlayfs will
also benefit from a smarter way to fetch the information.

> The point is that this sysfs is not going to be the standard for all the
> fs that can return the FS_XFLAG_CASEFOLD, so I see no reason
> to add this sysfs interface to ovl.

Ack.  I'll drop patches 3 and 4 and wait on ext4 people to see if they want
patch 2 to match f2fs. Will also keep an eye on FS_XFLAG_CASEFOLD.

> Thanks,
> Amir.
>
> [1] https://lore.kernel.org/linux-fsdevel/20250216164029.20673-4-pali@ker=
nel.org/
> [2] https://lore.kernel.org/linux-fsdevel/20251211152116.480799-2-cel@ker=
nel.org/

--=20
Gabriel Krisman Bertazi
