Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7EAAC4167B
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Nov 2023 10:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjKNK36 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 05:29:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjKNK35 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Nov 2023 05:29:57 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A1D83
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 02:29:54 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CB15D2189A;
        Tue, 14 Nov 2023 10:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1699957791;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uu/Nhwi08iGuuwkPdaiBlrUtG2YkY+bjeMc3BwqIpf0=;
        b=wM3FG+f02dQM4MSJPEmZK8ue0Ua2nqafdCXSuKmd6NPhLRiPXnUcISYRjCDgDtvObPUXYP
        HSi/YUwN5NtL91lcTFeFTUQGncA4lvtQGBkxE4ZAuFs9Os6FY4q/ZTF7c00OSGoOqX0DCA
        FaxzruO69S27KMYx6rAyi5DWJA0SFJU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1699957791;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uu/Nhwi08iGuuwkPdaiBlrUtG2YkY+bjeMc3BwqIpf0=;
        b=74B5RXk7aXb244AdbmBAZ3fTzEw6BLiJ5OlrXzByZIP/mmTqLoKlPLSVNQEqozfCdgp7cV
        A4f2ctpM17BZAJCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8523313416;
        Tue, 14 Nov 2023 10:29:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id RZc1Hx9MU2XJMQAAMHmgww
        (envelope-from <pvorel@suse.cz>); Tue, 14 Nov 2023 10:29:51 +0000
Date:   Tue, 14 Nov 2023 11:29:50 +0100
From:   Petr Vorel <pvorel@suse.cz>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Cyril Hrubis <chrubis@suse.cz>, Jan Kara <jack@suse.cz>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, ltp@lists.linux.it
Subject: Re: [PATCH 1/2] fanotify13: Test overlayfs while watching lower fs
Message-ID: <20231114102950.GA2325395@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20231114072338.1669277-1-amir73il@gmail.com>
 <20231114072338.1669277-2-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231114072338.1669277-2-amir73il@gmail.com>
Authentication-Results: smtp-out1.suse.de;
        none
X-Spamd-Result: default: False [-6.30 / 50.00];
         ARC_NA(0.00)[];
         HAS_REPLYTO(0.30)[pvorel@suse.cz];
         REPLYTO_EQ_FROM(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         RCPT_COUNT_FIVE(0.00)[6];
         NEURAL_HAM_LONG(-3.00)[-1.000];
         DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         FREEMAIL_TO(0.00)[gmail.com];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         MID_RHS_NOT_FQDN(0.50)[];
         RCVD_COUNT_TWO(0.00)[2];
         RCVD_TLS_ALL(0.00)[];
         BAYES_HAM(-3.00)[99.99%]
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Amir,

Reviewed-by: Petr Vorel <pvorel@suse.cz>

Kind regards,
Petr
