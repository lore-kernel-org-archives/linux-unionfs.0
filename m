From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 04/17] ovl: decode connected upper dir file handles
Date: Fri, 5 Jan 2018 17:34:23 +0200
Message-ID: <CAOQ4uxguTbgtEbst5vzoPMEW36=tgzgJoUUFATogBY+_eRVY_A@mail.gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
 <1515086449-26563-5-git-send-email-amir73il@gmail.com> <CAOQ4uxhpNCUzcuFSvntAN_JDB=L5NDqZP4m9TxytyO-P6t3F0Q@mail.gmail.com>
 <20180105151820.GA28246@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20180105151820.GA28246@fieldses.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "J . Bruce Fields" <bfields@fieldses.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jeff Layton <jlayton@poochiereds.net>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Jan 5, 2018 at 5:18 PM, J . Bruce Fields <bfields@fieldses.org> wrote:
> On Fri, Jan 05, 2018 at 02:33:22PM +0200, Amir Goldstein wrote:
>> There. Now you see why I did not want this story in commit message?
>
> No.  I think it's interesting, and might be useful to have around if
> someone needs to revisit this decision in the future.  So I'd rather
> have it in the changelog or in code comments.  I've had to track down
> old mailing list threads for this kind of information in the past and
> found it sometimes time-consuming.
>

Fair enough, but I'll wait to hear from Miklos first, because he may
have different arguments, or maybe he will call BS on some of my
arguments.

Thanks,
Amir.
