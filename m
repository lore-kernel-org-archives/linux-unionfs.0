From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATH 4/4] ovl: relax lock_rename when moving files between
 work and upper dir
Date: Thu, 12 Jan 2017 20:18:03 +0200
Message-ID: <CAOQ4uxjq0frWu+fidmkJKjPDV5wtvhNPCPC1-xqaPJiOt8+toQ@mail.gmail.com>
References: <CAOQ4uxgDhyy1z4xJgvA7c_mPvaYiNhi22DHpYM4X2SODtSwP1Q@mail.gmail.com>
 <20161110235444.GO19539@ZenIV.linux.org.uk> <CAOQ4uxiR6wsk97jQ43hu=hkJ1JQRaerSSEwjVr8tX6ia-yfOgA@mail.gmail.com>
 <20161111002756.GP19539@ZenIV.linux.org.uk> <CAOQ4uxibJf7BVSOeRdfcE7VtU2rkrii=Pu9OL0uZPavpudODeQ@mail.gmail.com>
 <20161111154034.GR19539@ZenIV.linux.org.uk> <CAOQ4uxgU3Pv_SRJhfOGVevuGop=fQ=rPK01UO0ccgy1yEM_hJA@mail.gmail.com>
 <20161111172737.GS19539@ZenIV.linux.org.uk> <CAJfpeguTOvO9P+khKxOX_-SBjePzeLqUqQ2B9sBszjamD3wWvA@mail.gmail.com>
 <CAOQ4uxhrGRPg68SRQhyS=_PEe9SO9fkFv_=GUSELr_A=HSH0FQ@mail.gmail.com> <20170112100056.GF27207@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170112100056.GF27207@veci.piliscsaba.szeredi.hu>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Konstantin Khlebnikov <koct9i@gmail.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Jan 12, 2017 at 12:00 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Jan 12, 2017 at 07:42:22AM +0200, Amir Goldstein wrote:
>> I think you suggested here to use a waitqueue for pending copyups?
>> Did you mean a waitqueue per overlay parent directory inode or
>> did you mean something else?
>
> Something like this:
>

That's a useful answer :)
I'll give it a try.
Thanks!
