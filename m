From: Richard Weinberger <richard@nod.at>
Subject: Re: copy up questions
Date: Sun, 9 Apr 2017 13:37:24 +0200
Message-ID: <53e761f4-b615-15c7-8a1b-cb70a5535629@nod.at>
References: <CAL-1w2sXhnGVW5-3AyUgSjEy4ebk1ftDzoaadhn9n4_Qf7kD8A@mail.gmail.com>
 <CAOQ4uxgWAOqUNHaNBTtL49PEshQuL9SAa9Ec0F63J-LM8KH7Uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from b.ns.miles-group.at ([95.130.255.144]:44723 "EHLO radon.swed.at"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752067AbdDILh2 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 9 Apr 2017 07:37:28 -0400
In-Reply-To: <CAOQ4uxgWAOqUNHaNBTtL49PEshQuL9SAa9Ec0F63J-LM8KH7Uw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>, Rock Lee <rockdotlee@gmail.com>
Cc: linux-unionfs@vger.kernel.org

Amir, Rock Lee,

Am 09.04.2017 um 10:43 schrieb Amir Goldstein:
 > Well, that's a question for UBIFS folks [cc: Richard] , but I can tell
> you this much
> b-tree structure is a good starting point for reflink, but that
> doesn't mean that
> the implementation of reflink is trivial.

UBIFS is older than reflinks and UBIFS has no machinery for this feature.
Mostly because nobody really wanted this feature. In combination with overlayfs
it makes now sense to support that.
I agree with Amir that B-Trees are a good start but UBIFS will lacks some
bits to support that, for example reverse block maps.

Doable, sure. On a rainy weekend, no. :-)

Thanks,
//richard
