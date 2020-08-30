Return-Path: <SRS0=vlVb=CI=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E541C433E6
	for <linux-unionfs@archiver.kernel.org>; Sun, 30 Aug 2020 11:30:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A889207DA
	for <linux-unionfs@archiver.kernel.org>; Sun, 30 Aug 2020 11:30:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dYmTJVFJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728822AbgH3Laf (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 30 Aug 2020 07:30:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29645 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726406AbgH3Lae (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 30 Aug 2020 07:30:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598787031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ETh2SfT4KHd+5n3USTDSMP5uiOB3sVlZ/3ww+QanKH8=;
        b=dYmTJVFJZ+XIxva4R7R+LrIjs4o2Ai2rF9n0c13hRLvooEC5ZW/iALF/l6UvovUSwiLYaU
        P4mzdaELSJ5QHP6mDgo/XR8CUlR2v3IdAUoO13qjwi0rGU4QEvKIC/nhu8A6NGjfw2oh3N
        ZlC3MZRFwtrQOhx7WKm5VD+9PAN9XLU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-hz1v0BwXPy6kfSE3UYxG2A-1; Sun, 30 Aug 2020 07:30:27 -0400
X-MC-Unique: hz1v0BwXPy6kfSE3UYxG2A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB5A0189E628;
        Sun, 30 Aug 2020 11:29:55 +0000 (UTC)
Received: from localhost (ovpn-112-59.ams2.redhat.com [10.36.112.59])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 950007838E;
        Sun, 30 Aug 2020 11:29:54 +0000 (UTC)
From:   Giuseppe Scrivano <gscrivan@redhat.com>
To:     Sargun Dhillon <sargun@sargun.me>
Cc:     Aleksa Sarai <asarai@suse.de>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: Overlayfs @Plumbers
References: <CAOQ4uxjXZdXZAaeiJ_p9n7NJziBv2yvWqSDs0hDd1ONUrVKxOQ@mail.gmail.com>
        <87tuwmiy4j.fsf@x220.int.ebiederm.org>
        <20200828155849.k46uk3x63aio3g3o@yavin.dot.cyphar.com>
        <CAMp4zn83CwpfuFq7+JSkYGZmFC03pUrt_30Wzn42AxqAaSDSpg@mail.gmail.com>
Date:   Sun, 30 Aug 2020 13:29:51 +0200
In-Reply-To: <CAMp4zn83CwpfuFq7+JSkYGZmFC03pUrt_30Wzn42AxqAaSDSpg@mail.gmail.com>
        (Sargun Dhillon's message of "Sat, 29 Aug 2020 08:40:36 -0700")
Message-ID: <87imd09xsg.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Sargun,

Sargun Dhillon <sargun@sargun.me> writes:

Q> On Fri, Aug 28, 2020 at 8:59 AM Aleksa Sarai <asarai@suse.de> wrote:
>>
>> On 2020-08-28, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> > Amir Goldstein <amir73il@gmail.com> writes:
>> >
>> > > Hi Guys,
>> > >
>> > > It's been nice to virtually meet with you yesterday.
>> > > Some of you wanted to follow up on overlayfs related issues.
>> > >
>> > > If you want to discuss, try to find me in one of the
>> > > https://meet.2020.linuxplumbersconf.org/hackrooms
>> > > today between 16:00-17:00 UTC
>> > > (No need to enter the room to see who's inside)
>> > >
>> > > If those times do not work for you, contact me and we can try
>> > > to schedule another time.
>> >
>> > Did this conversation wind up happening?  Do we need to reschedule?
>>
>> This conversation already happened in a Hackroom on Tuesday. I'm not
>> sure if the Hackrooms will have their recordings published, so maybe
>> Amir can post any of the takeaways we had?
>>
>> --
>> Aleksa Sarai
>> Senior Software Engineer (Containers)
>> SUSE Linux GmbH
>> <https://www.cyphar.com/>
>
> I unfortunately missed this conversation. I wanted to bring up OverlayFS, and
> ephemeral upper dirs. We use overlayfs with Docker containers, and we waste
> a lot of time on writing things back to disk.
>
> We're not so peeved about the fact that OVL does any sync operations, as that's
> what our users have been used to. The big problem is on unmount, ovelfs decides
> syncing the upperdirs is a good idea. IIRC, this regression was
> introduced somewhere
> in the 4.X series.
>
> We've been carrying a patch to short-circuit this behaviour for a while now:
> https://github.com/Netflix-Skunkworks/linux/commit/edb195d9b73cc22d095078010a14a690f41ee253
>
> I know that this behaviour (and any behaviour that short-circuits
> O_SYNC / FUA is
> technically "wrong", but in this case, can we make an exception? I originally
> thought about using device mapper to remove the FUA bit from all BIOs, but it
> turns out that my underlying storage *always* persists data to disk,
> so every write
> takes...a long time.
>
> Amir, what's your take?

we are having the same issue when building images.  Would the following
patch be helpful?

https://www.spinics.net/lists/linux-unionfs/msg08267.html

Regards,
Giuseppe

