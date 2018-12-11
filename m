From: Paul Moore <paul@paul-moore.com>
Subject: Re: overlayfs access checks on underlying layers
Date: Tue, 11 Dec 2018 10:50:17 -0500
Message-ID: <CAHC9VhSV4a949kvh8Tq1acXzRddW915naWiaG-yqVS1_JyqgEQ@mail.gmail.com>
References: <CAJfpegs9JjkXguemL4qSiBvRP6Dnut-D+nJo-oLFXkfCL1Egvw@mail.gmail.com>
 <CAJfpegvfqx+0D32n1h2X7oj5d1mZWiLTcSSGpBnD+ba7AKzPyA@mail.gmail.com>
 <20181127210542.GA2599@redhat.com> <CAJfpegtQGM2z9TOt3DWwd39fC60cQknsC4vNnj7YimVEubRzUg@mail.gmail.com>
 <20181128170302.GA12405@redhat.com> <377b7d4f-eb1d-c281-5c67-8ab6de77c881@tycho.nsa.gov>
 <CAJfpegtNhcWD0VWy6LPtoDtQBfPu4x5iFsB053UMCidj6oMsuw@mail.gmail.com>
 <26bce3be-49c2-cdd8-af03-1a78d0f268ae@tycho.nsa.gov> <CAJfpeguL9xOh9Eq8LOP=ddJ4YD6nbp2UY6e2AYDVoHeCLuVhZA@mail.gmail.com>
 <6b125e8e-413f-f8e6-c7ae-50f7235c8960@tycho.nsa.gov> <CAJfpegv6y56k1-Tewu-Pu3x1W75LL6qYB6Hb6=n+2BJoNfEigA@mail.gmail.com>
 <c993dba4-5129-7f04-2724-a82a1f1cafa3@tycho.nsa.gov> <f84bbe0b-f4c1-50e0-8c84-a6589154b3ae@tycho.nsa.gov>
 <CAJfpegtBDTMbmKd6eDxRmtSJjGN6CnpGK_QPNSsxjkOoeu=1pQ@mail.gmail.com>
 <4c20a261-5ce1-f0a2-8d40-c6032a023216@tycho.nsa.gov> <CAJfpegujwNpWL5Eujrb+=EQF8OMOkO03yq8ZZSkfhFfwQvhGKQ@mail.gmail.com>
 <6feb656e-b1e3-5839-ce5f-669ae5a55b7f@tycho.nsa.gov> <CAJfpeguJoEOEjQs4ZpJQaJXF-xCnevUApzNobwmqNX27KQ4vHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpeguJoEOEjQs4ZpJQaJXF-xCnevUApzNobwmqNX27KQ4vHQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: miklos@szeredi.hu
Cc: Stephen Smalley <sds@tycho.nsa.gov>, vgoyal@redhat.com, omosnace@redhat.com, bfields@fieldses.org, salyzyn@android.com, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org, Dan Walsh <dwalsh@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Dec 4, 2018 at 10:39 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, Dec 4, 2018 at 4:32 PM Stephen Smalley <sds@tycho.nsa.gov> wrote:
>
> > Ok, I concede the point.  Not sure what that means though for v4.20.
>
> I have the revert queued up for v4.20 as that's the safest.

Miklos, when do you plan on sending the revert to Linus?  I just
tested v4.20-rc6 and the problem persists.

-- 
paul moore
www.paul-moore.com
