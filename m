Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DC25505F0
	for <linux-unionfs@vger.kernel.org>; Tue, 29 Sep 2026 15:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790695122; cv=none; b=ex9xCXRHIY8CgL12Uidt3TaCCPXmQsFZMv/my2xgMrtlpzSlzRnemdm/RksDLTMo9Awy5xEruMmXcD7s81QpnMzb1B1Epveachg0PkUVktET19UPgES3VSbGAArBncUixFRv43RLX5B9OMoitTRFZH37wkjTeoGQ69if1amBB5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790695122; c=relaxed/simple;
	bh=IdlfE/0IN7jnx34wF4FHPe8sY3d07GaAKiwDoJu985g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=U42dyK+d1Srx0A7Mo1QwpxSD4cZJ0RITWKdk2lQmWoaM0FUtYQKoL++sztpGPhtg7PmBDUdSNFvnNZulK+jc9O3aWyubgaNZ+FilwP8FFy30PVMMaKHMyIcpRKLjPvigJ4mdSm/i/73PEKuFEluiCZO+Zy8oxxy5erqrPmRLWJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FhmKD1uZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=OPus6TxJ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kxes/HB8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rjsr+u//; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FhmKD1uZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="OPus6TxJ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kxes/HB8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rjsr+u//"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B377C1F456;
	Tue, 29 Sep 2026 15:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790695074; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dqE/tOpPrIzgQZLhm+Z18s/mfusUAgnOtaHMUgYsSYI=;
	b=FhmKD1uZ+D1tKU0bH1FjxjvYxpijB0xvxeMTJEQPhxHMPCLL8KP/ie37FxVToB2WoFg7wZ
	/XNDaKmgwRre+HChcMbXS+RqmxESJNlDvLDq1Lbax5VkPQWWEOomwn4mS27Oauq6xYGAPX
	fEn6pSeszUs/2VvKL3j5+IE7Np7gYXk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790695074;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dqE/tOpPrIzgQZLhm+Z18s/mfusUAgnOtaHMUgYsSYI=;
	b=OPus6TxJiV1lnxy+HcUOdE3RaGJOkzLa4lCz7H+KB5MPJhXNqq6ku+YF8oXC0PuqnPkwuZ
	bcQzVDvQHKT4GIDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="kxes/HB8";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="rjsr+u//"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790695070; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dqE/tOpPrIzgQZLhm+Z18s/mfusUAgnOtaHMUgYsSYI=;
	b=kxes/HB886QxNRlbafjLvkinCh/oM+qExAPu2izP/lplup8KjYOC3+shmurmNZ2Goz2we7
	9oJuKtQipIUmFPMJ52LdfdNXtaw0PaTVqu/K3eN9q0JgHPB9HVup5OvuepiheKDaGCN7+n
	BvZqKXQqlRWk7QwbKmmR9MZ3rc9Ovp4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790695070;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dqE/tOpPrIzgQZLhm+Z18s/mfusUAgnOtaHMUgYsSYI=;
	b=rjsr+u//fdqi5GbZtrGiYWKNlkkmAmD2w/rjyRRJMSf/HKbh45tR23pUY5zna8YPLovxL0
	MDYAsrlwjrBy+IDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 45047136E4;
	Tue, 29 Sep 2026 15:17:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9oqPA57Wu2qXFQAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 29 Sep 2026 15:17:50 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Mohammed EL Kadiri <med08elkadiri@gmail.com>
Cc: amir73il@gmail.com, brauner@kernel.org, danielzgtg.opensource@gmail.com,
 hughd@google.com, jack@suse.cz, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-unionfs@vger.kernel.org, miklos@szeredi.hu, tytso@mit.edu
Subject: Re: [PATCH 1/4] shmem: Report casefold setting in mount options
In-Reply-To: <20260929140011.211148-1-med08elkadiri@gmail.com>
Organization: SUSE
References: <20260928213155.2612039-1-krisman@suse.de>
 <20260928213155.2612039-2-krisman@suse.de>
 <20260929140011.211148-1-med08elkadiri@gmail.com>
Date: Tue, 29 Sep 2026 11:17:48 -0400
Message-ID: <87pkxwxf1f.fsf@mailhost.krisman.be>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	URIBL_BLOCKED(0.00)[mailhost.krisman.be:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[gmail.com,kernel.org,google.com,suse.cz,vger.kernel.org,kvack.org,szeredi.hu,mit.edu];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: B377C1F456
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

Mohammed EL Kadiri <med08elkadiri@gmail.com> writes:

> On Mon, Sep 28, 2026 at 05:31:52PM -0400, Gabriel Krisman Bertazi wrote:
>> For shmem, casefolding is a mount option.  Report the current encoding
>> and casefolding flags in /proc/mounts
>
> This works for me, on 90ddfbd19636 (akpm/mm-unstable), x86_64,
> CONFIG_UNICODE=y:
>
>   # mount -t tmpfs -o casefold tmpfs /t
>   # grep /t /proc/mounts
>   tmpfs /t tmpfs rw,relatime,casefold=utf8-12.1.0 0 0
>
> Tested-by: Mohammed EL Kadiri <med08elkadiri@gmail.com>

Thanks!

>
> Heads-up on one side effect, since mount(8) builds its remount options
> from /proc/mounts: once casefold= is listed there, it gets passed back on
> every remount.
>
>   # mount -t tmpfs -o casefold tmpfs /t
>   [  527.593309] tmpfs: Using encoding : utf8-12.1.0
>   # mount -o remount,size=64M /t
>   [  527.595716] tmpfs: Using encoding : utf8-12.1.0

This is desired behavior, IMO.  You should not lose casefold during a
remount, at risk of botching your data/splitting unrelated files. Also
this is the reason why I didn't expose it directly in /proc/mounts for
ovl, it would be easier but break the remount.

> That second line is shmem_parse_opt_casefold() running on a remount that
> only asked to change size.  It calls utf8_load() each time, and nothing
> frees the result - shmem_reconfigure() doesn't look at ctx->encoding and
> shmem_free_fc() doesn't unload it.  50000 such remounts grew kmalloc-32 by
> ~50000 objects; a tmpfs without casefold stays flat.
>
> The leak predates this patch - you can trigger it by passing casefold= on
> a remount by hand - so I sent the fix as a separate patch:
>
> https://lore.kernel.org/all/ba38f80f629fd093c77f3a49fdab7b71ee7bbc5f.1790687276.git.med08elkadiri@gmail.com/

Thanks for reporting and fixing this.  feel free to cc me on further
unicode stuff.  Will review it right now.

Thanks,

-- 
Gabriel Krisman Bertazi
