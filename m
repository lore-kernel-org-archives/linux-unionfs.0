Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED412C237C
	for <linux-unionfs@vger.kernel.org>; Tue, 29 Sep 2026 15:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790696172; cv=none; b=BlueP3heBWs8DOGrtpAdf8IbeunPP7PWOkV/coIEGPNONmm59qRlPU2zQG2g3yR0QBo9UpVFi3fxueLHMMeC8Il0wFL9NG1ySqFOerDSrCtXiGCstRKaPF7c88ssOO1yJ6RJu0ZLME4uc+eDcTogxBbrrpzvOTG42B95HPaKYd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790696172; c=relaxed/simple;
	bh=dJ+teJJ6nyP49pH9Qv+qmG4wRUKs0zIMYBw7U2m7jiw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ilc1NlWJFqz3VuubjmwAuFvmDLdpdLJsBfbsmtch/o+A31MyT5T+2AEOXyV7t5NtE7f4eBhBavOVB1rheiLghOTGCcEwDoGAHpT2SSLlu/zHztdXpNwbxa0fn4spJxCPI12fza+jgX/vxvP11qd2Sgoa4ymKubv4jWlowuYKvug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sTGZSRl2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ie2AEQyS; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=gamWqDUt; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/GQdw1NJ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sTGZSRl2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ie2AEQyS";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gamWqDUt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/GQdw1NJ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D0C771F79C;
	Tue, 29 Sep 2026 15:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790696156; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yMrm96DArMa2on1T2OU8poCiT/Ajlmru9xAu5CV6dbY=;
	b=sTGZSRl2gb/ZI0qsUPV3bN/ycC4DOfvy0k8jSRYRu3cJDqFnn4MGY45KEk8RogeTeiPdHa
	vUG0ZFjm2qoCr3arXbNQjJBU5OdETEhnTgwrFFv8W8eImBLyPjUvWmTsj0Snpba2OSetfS
	DCf6sEK6IK/dVrdrB9H/QNdXJVoOAcM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790696156;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yMrm96DArMa2on1T2OU8poCiT/Ajlmru9xAu5CV6dbY=;
	b=ie2AEQySndq9FaLcpcsC0PYLPt1l6WpyPcbdBBy6ica2ycsMHWP7daV1brC11IQSohKNlj
	rpUOyuMe3Gf/ZSCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gamWqDUt;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/GQdw1NJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790696151; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yMrm96DArMa2on1T2OU8poCiT/Ajlmru9xAu5CV6dbY=;
	b=gamWqDUtEANmJfk8jCSlqDWHELAoBaqUUJIOvWZRf9sxyxjNCDZfHorSql8Qs4cn8rB66v
	O0wOZpdI8SgwF9UUxlIsxTf9iDK8SGWZNBPSN0Bm/u9kPcNbyVPjtXnXlXYUkiJdCn1qFF
	PEDwWkmRpXJUUALVhl0Ugus0ZHAvrfE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790696151;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yMrm96DArMa2on1T2OU8poCiT/Ajlmru9xAu5CV6dbY=;
	b=/GQdw1NJ6k1WzzehfohpLY+HtIMSmnqQG0xeAHCPbhqYk1is3nMa5jvQtPH4QQ2G+7HlG5
	5P9GjvlmBt2ykUAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4D37C136E4;
	Tue, 29 Sep 2026 15:35:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id y8YsBdfau2rwKAAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 29 Sep 2026 15:35:51 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>, Amir Goldstein
 <amir73il@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, Hugh Dickins
 <hughd@google.com>, Daniel Tang <danielzgtg.opensource@gmail.com>,
 linux-ext4@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
 linux-unionfs@vger.kernel.org, linux-mm@kvack.org, Chuck Lever
 <cel@kernel.org>
Subject: Re: [PATCH 4/4] ovl: Expose the filesystem encoding through sysfs
In-Reply-To: <20260929144043.5rg4zf7uth333qke@pali>
Organization: SUSE
References: <20260928213155.2612039-1-krisman@suse.de>
 <20260928213155.2612039-5-krisman@suse.de>
 <CAOQ4uxj7Vx-UGvgGGr9hPC0qUgJZ_WRAv1ZLi=gJ6r=ZJW0QAQ@mail.gmail.com>
 <20260929144043.5rg4zf7uth333qke@pali>
Date: Tue, 29 Sep 2026 11:35:49 -0400
Message-ID: <87jyo4xe7e.fsf@mailhost.krisman.be>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:email,mailhost.krisman.be:mid];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	FREEMAIL_TO(0.00)[kernel.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,suse.cz,mit.edu,google.com,gmail.com,szeredi.hu,kvack.org];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:email,mailhost.krisman.be:mid]
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: D0C771F79C
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

Pali Roh=C3=A1r <pali@kernel.org> writes:

> On Tuesday 29 September 2026 16:15:04 Amir Goldstein wrote:
>> On Mon, Sep 28, 2026 at 11:32=E2=80=AFPM Gabriel Krisman Bertazi
>> <krisman@suse.de> wrote:
>> >
>> > This patch reproduces the same interface from ext4/f2fs to have feature
>> > parity, so users don't need to rely on parsing dmesg or trying +F on a
>> > temporary directory just to check for support.  Note there is no
>> > encoding_flags file, as none are supported by ovl.
>> >
>>=20
>> Gabriel,
>>=20
>> I am not ok with this API.
>> It is wrong in several ways.
>> It is not generic, we have already file_getattr() to get casefold status.
>> There was a suggestion by Pali [1] to get the supported xflags - statx s=
tyle,
>> which can be a way to say if a fs could return FS_XFLAG_CASEFOLD.
>
> Yea, sorry for that. I have not finished it, I did not have time. But I
> would like to address this as this is something was was asked more
> times...

please cc me when sending it.=20

--=20
Gabriel Krisman Bertazi
